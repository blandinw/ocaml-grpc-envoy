(** kv.proto Types *)



(** {2 Types} *)

type get_request = {
  key : string;
}

type get_response = {
  value : string;
}

type set_request = {
  key : string;
  value : string;
}

type set_response = {
  ok : bool;
}


(** {2 Default values} *)

val default_get_request : 
  ?key:string ->
  unit ->
  get_request
(** [default_get_request ()] is the default value for type [get_request] *)

val default_get_response : 
  ?value:string ->
  unit ->
  get_response
(** [default_get_response ()] is the default value for type [get_response] *)

val default_set_request : 
  ?key:string ->
  ?value:string ->
  unit ->
  set_request
(** [default_set_request ()] is the default value for type [set_request] *)

val default_set_response : 
  ?ok:bool ->
  unit ->
  set_response
(** [default_set_response ()] is the default value for type [set_response] *)
