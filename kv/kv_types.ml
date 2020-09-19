[@@@ocaml.warning "-27-30-39"]


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

let rec default_get_request 
  ?key:((key:string) = "")
  () : get_request  = {
  key;
}

let rec default_get_response 
  ?value:((value:string) = "")
  () : get_response  = {
  value;
}

let rec default_set_request 
  ?key:((key:string) = "")
  ?value:((value:string) = "")
  () : set_request  = {
  key;
  value;
}

let rec default_set_response 
  ?ok:((ok:bool) = false)
  () : set_response  = {
  ok;
}
