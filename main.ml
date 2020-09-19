open Httpaf
open Lwt.Infix
open Lwt_io

let envoy_host = "localhost"

let envoy_port = "9911"

(* etcd *)

exception Rpc_failure of string

let perform_request path proto =
  let proto_len = String.length proto in
  (* account for null byte + uint32 *)
  let payload = Bytes.create @@ (proto_len + 1 + 4) in
  Bytes.set payload 0 '\x00';
  Binary_packing.pack_unsigned_32_int_big_endian ~buf:payload ~pos:1
    (String.length proto);
  Bytes.blit_string proto 0 payload 5 proto_len;
  let payload_str = Bytes.to_string payload in
  let payload_len = String.length payload_str in

  Lwt_unix.getaddrinfo envoy_host envoy_port [ Unix.(AI_FAMILY PF_INET) ]
  >>= fun addrs ->
  let socket = Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  Lwt_unix.connect socket (List.hd addrs).Unix.ai_addr >>= fun () ->
  let finished, notify_finished = Lwt.wait () in
  let error_handler e =
    let ret =
      match e with
      | `Malformed_response err ->
          Rpc_failure (Format.sprintf "Malformed response: %s" err)
      | `Invalid_response_body_length _ -> Rpc_failure "Invalid body length"
      | `Exn exn -> exn
    in
    Lwt.wakeup_later_exn notify_finished ret
  in
  let response_handler (rsp : Response.t) rsp_body =
    match rsp.status with
    | `OK ->
        let rsp_proto = Bytes.create 4096 in
        let read = ref 0 in
        let rec on_read buffer ~off ~len =
          Bigstringaf.blit_to_bytes ~src_off:0 buffer ~dst_off:off rsp_proto
            ~len;
          read := !read + len;
          Body.schedule_read rsp_body ~on_read ~on_eof
        and on_eof () =
          Lwt.wakeup_later notify_finished (Bytes.sub rsp_proto 5 (!read - 5))
        in
        Body.schedule_read rsp_body ~on_read ~on_eof
    | _ ->
        Format.fprintf Format.str_formatter "%a" Response.pp_hum rsp;
        Lwt.wakeup_later_exn notify_finished
          (Rpc_failure (Format.stdbuf |> Buffer.to_bytes |> Bytes.to_string))
  in

  let headers =
    Headers.of_list
      [
        ("content-length", Int.to_string payload_len);
        ("content-type", "application/grpc");
        ("host", "etcd");
      ]
  in
  let request_body =
    Httpaf_lwt_unix.Client.request ~error_handler ~response_handler socket
      (Request.create ~headers `POST ("/etcdserverpb.KV" ^ path))
  in
  Body.write_string request_body payload_str;
  Body.close_writer request_body;
  finished

let etcd_get key =
  let req =
    Etcd.Etcd_types.default_range_request ~key:(Bytes.of_string key) ()
  in
  let encoder = Pbrt.Encoder.create () in
  Etcd.Etcd_pb.encode_range_request req encoder;
  perform_request "/Range" (Pbrt.Encoder.to_string encoder) >|= fun rsp_proto ->
  let decoder = Pbrt.Decoder.of_bytes rsp_proto in
  Etcd.Etcd_pb.decode_range_response decoder

let etcd_put key value =
  let req =
    Etcd.Etcd_types.default_put_request ~key:(Bytes.of_string key)
      ~value:(Bytes.of_string value) ()
  in
  let encoder = Pbrt.Encoder.create () in
  Etcd.Etcd_pb.encode_put_request req encoder;
  perform_request "/Put" @@ Pbrt.Encoder.to_string encoder >|= fun rsp_proto ->
  let decoder = Pbrt.Decoder.of_bytes @@ rsp_proto in
  Etcd.Etcd_pb.decode_put_response decoder

(* gRPC *)

let kv_get decoder encoder =
  let req = Kv.Kv_pb.decode_get_request decoder in
  etcd_get req.key >|= fun rsp ->
  Kv.Kv_pb.encode_get_response
    { value = (List.hd rsp.kvs).value |> Bytes.to_string }
    encoder

let kv_set decoder encoder =
  let req = Kv.Kv_pb.decode_set_request decoder in
  etcd_put req.key req.value >|= fun _ ->
  Kv.Kv_pb.encode_set_response { ok = true } encoder

(* HTTP *)

let start_server port =
  let addr = Unix.inet_addr_any in
  let listen_address = Unix.(ADDR_INET (addr, port)) in
  let request_handler _ reqd =
    let req = Reqd.request reqd in
    let headers =
      Headers.to_list req.headers
      |> List.map (fun (k, v) -> k ^ ": " ^ v)
      |> String.concat ", "
    in
    let respond_with ?(status = `OK) body headers =
      Lwt.return
      @@ Reqd.respond_with_string reqd
           (Response.create
              ~headers:
                (Headers.of_list
                   (List.append
                      [
                        ("content-length", Int.to_string @@ String.length body);
                      ]
                      headers))
              status)
           body
    in
    let grpc_handler f =
      let p, notify_p = Lwt.wait () in
      let req_body = Reqd.request_body reqd in
      let req_proto = Bytes.create 4096 in
      let read = ref 0 in
      let rec on_read buffer ~off ~len =
        Bigstringaf.blit_to_bytes ~src_off:0 buffer ~dst_off:off req_proto ~len;
        read := !read + len;
        Body.schedule_read req_body ~on_read ~on_eof
      and on_eof () =
        let decoder = Pbrt.Decoder.of_bytes (Bytes.sub req_proto 0 !read) in
        let encoder = Pbrt.Encoder.create () in

        ignore
        @@ Lwt.catch
             (fun _ ->
               f decoder encoder >|= fun () ->
               let rsp_str = Pbrt.Encoder.to_string encoder in
               let rsp_body =
                 Reqd.respond_with_streaming reqd
                   (Response.create
                      ~headers:
                        (Headers.of_list
                           [
                             ("content-type", "application/grpc");
                             ( "content-length",
                               Int.to_string @@ String.length rsp_str );
                           ])
                      `OK)
               in
               Body.write_string rsp_body rsp_str;
               Body.close_writer rsp_body)
             (fun exn -> Lwt.return @@ Lwt.wakeup_later_exn notify_p exn)
      in

      Body.schedule_read req_body ~on_read ~on_eof;
      p
    in

    ignore
    @@ Lwt.catch
         (fun _ ->
           eprintf "%s %s (%s)\n" (Method.to_string req.meth) req.target headers
           >>= fun _ ->
           match req.meth with
           | `GET -> respond_with "pong\n" []
           | `POST -> (
               match req.target with
               | "/kv.KV/Get" -> grpc_handler kv_get
               | "/kv.KV/Set" -> grpc_handler kv_set
               | _ -> respond_with "grpc method not found\n" [] )
           | _ -> respond_with ~status:`Not_found "not found\n" [])
         (fun exn ->
           Reqd.report_exn reqd exn;
           Lwt.return_unit)
  in

  let error_handler _ ?request:_ error start_response =
    let response_body = start_response Headers.empty in

    ignore
    @@ ( eprintf "error: %s\n"
           ( match error with
           | `Bad_request -> "bad request"
           | `Bad_gateway -> "bad gateway"
           | `Internal_server_error -> "internal server error"
           | `Exn exn -> Printexc.to_string exn )
       >|= fun _ ->
         Body.write_string response_body "Something went wrong.\n";
         Body.close_writer response_body )
  in
  let connection_handler =
    Httpaf_lwt_unix.Server.create_connection_handler ~request_handler
      ~error_handler
  in
  Lwt.async (fun () ->
      Lwt_io.establish_server_with_client_socket listen_address
        connection_handler
      >>= fun _server ->
      eprintf "Listening on %s:%d.\n" (Unix.string_of_inet_addr addr) port);
  let forever, _ = Lwt.wait () in
  Lwt_main.run forever

let () =
  let port = int_of_string Sys.argv.(1) in
  start_server port
