{ lib, fetchurl, buildOasisPackage, camlp4, cairo2 }:

buildOasisPackage rec {
  minimumOCamlVersion = "4.03";
  pname = "archimedes";
  version = "0.4.18";
  src = fetchurl {
    url = https://download.ocamlcore.org/archimedes/archimedes/0.4.18/archimedes-0.4.18.tar.gz;
    sha256 = "1bgygy94lnif5zsq1n6086hy07lbb73d4qnf9p20jq7b4ril9yk4";
  };

  buildInputs = [ camlp4 ];

  propagatedBuildInputs = [ cairo2 ];

  doCheck = true;

  meta = {
    description = "OCaml 2D plotting library";
    longDescription = ''
      Archimedes is a high quality, platform-independent, extensible 2D
      plotting library. It provides dynamically loaded backends such as
      Graphics and Cairo.
    '';
    license     = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ kovirobi ];
    inherit (src.meta) homepage;
  };
}
