(** etcd.proto Binary Encoding *)


(** {2 Protobuf Encoding} *)

val encode_response_header : Etcd_types.response_header -> Pbrt.Encoder.t -> unit
(** [encode_response_header v encoder] encodes [v] with the given [encoder] *)

val encode_key_value : Etcd_types.key_value -> Pbrt.Encoder.t -> unit
(** [encode_key_value v encoder] encodes [v] with the given [encoder] *)

val encode_range_request_sort_order : Etcd_types.range_request_sort_order -> Pbrt.Encoder.t -> unit
(** [encode_range_request_sort_order v encoder] encodes [v] with the given [encoder] *)

val encode_range_request_sort_target : Etcd_types.range_request_sort_target -> Pbrt.Encoder.t -> unit
(** [encode_range_request_sort_target v encoder] encodes [v] with the given [encoder] *)

val encode_range_request : Etcd_types.range_request -> Pbrt.Encoder.t -> unit
(** [encode_range_request v encoder] encodes [v] with the given [encoder] *)

val encode_range_response : Etcd_types.range_response -> Pbrt.Encoder.t -> unit
(** [encode_range_response v encoder] encodes [v] with the given [encoder] *)

val encode_put_request : Etcd_types.put_request -> Pbrt.Encoder.t -> unit
(** [encode_put_request v encoder] encodes [v] with the given [encoder] *)

val encode_put_response : Etcd_types.put_response -> Pbrt.Encoder.t -> unit
(** [encode_put_response v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_response_header : Pbrt.Decoder.t -> Etcd_types.response_header
(** [decode_response_header decoder] decodes a [response_header] value from [decoder] *)

val decode_key_value : Pbrt.Decoder.t -> Etcd_types.key_value
(** [decode_key_value decoder] decodes a [key_value] value from [decoder] *)

val decode_range_request_sort_order : Pbrt.Decoder.t -> Etcd_types.range_request_sort_order
(** [decode_range_request_sort_order decoder] decodes a [range_request_sort_order] value from [decoder] *)

val decode_range_request_sort_target : Pbrt.Decoder.t -> Etcd_types.range_request_sort_target
(** [decode_range_request_sort_target decoder] decodes a [range_request_sort_target] value from [decoder] *)

val decode_range_request : Pbrt.Decoder.t -> Etcd_types.range_request
(** [decode_range_request decoder] decodes a [range_request] value from [decoder] *)

val decode_range_response : Pbrt.Decoder.t -> Etcd_types.range_response
(** [decode_range_response decoder] decodes a [range_response] value from [decoder] *)

val decode_put_request : Pbrt.Decoder.t -> Etcd_types.put_request
(** [decode_put_request decoder] decodes a [put_request] value from [decoder] *)

val decode_put_response : Pbrt.Decoder.t -> Etcd_types.put_response
(** [decode_put_response decoder] decodes a [put_response] value from [decoder] *)
