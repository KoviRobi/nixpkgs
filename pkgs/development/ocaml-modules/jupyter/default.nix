{ lib, fetchFromGitHub, buildDunePackage,
  uuidm, base64, lwt, lwt_ppx, logs, stdint, zmq, zmq-lwt, yojson, cryptokit,
  ppx_tools_versioned, ppx_deriving_yojson,
  merlin ? null }:

buildDunePackage rec {
  minimumOCamlVersion = "4.04";
  pname = "jupyter";
  version = "20190819";
  src = fetchFromGitHub {
    owner = "akabe";
    repo = "ocaml-jupyter";
    rev = "99951a6669dedc97e42b7d1c1374116228b4dc45";
    sha256 = "0562ri65fw6jlxv5s8w00v72j7cwmmbsi3bw77m5yrjrkbrshrjn";
  };

  buildInputs = [ ppx_tools_versioned ];

  propagatedBuildInputs = [ uuidm base64 lwt lwt_ppx logs stdint zmq zmq-lwt
                            yojson ppx_deriving_yojson cryptokit ];

  meta = {
    description = "Jupyter notebook kernel for OCaml";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kovirobi ];
    inherit (src.meta) homepage;
  };
}
