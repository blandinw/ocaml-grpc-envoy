(** kv.proto Binary Encoding *)


(** {2 Protobuf Encoding} *)

val encode_get_request : Kv_types.get_request -> Pbrt.Encoder.t -> unit
(** [encode_get_request v encoder] encodes [v] with the given [encoder] *)

val encode_get_response : Kv_types.get_response -> Pbrt.Encoder.t -> unit
(** [encode_get_response v encoder] encodes [v] with the given [encoder] *)

val encode_set_request : Kv_types.set_request -> Pbrt.Encoder.t -> unit
(** [encode_set_request v encoder] encodes [v] with the given [encoder] *)

val encode_set_response : Kv_types.set_response -> Pbrt.Encoder.t -> unit
(** [encode_set_response v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_get_request : Pbrt.Decoder.t -> Kv_types.get_request
(** [decode_get_request decoder] decodes a [get_request] value from [decoder] *)

val decode_get_response : Pbrt.Decoder.t -> Kv_types.get_response
(** [decode_get_response decoder] decodes a [get_response] value from [decoder] *)

val decode_set_request : Pbrt.Decoder.t -> Kv_types.set_request
(** [decode_set_request decoder] decodes a [set_request] value from [decoder] *)

val decode_set_response : Pbrt.Decoder.t -> Kv_types.set_response
(** [decode_set_response decoder] decodes a [set_response] value from [decoder] *)
