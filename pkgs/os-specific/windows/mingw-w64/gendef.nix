{ lib, stdenv, mingw_w64 }:

stdenv.mkDerivation {
  name = "${mingw_w64.name}-tools";
  inherit (mingw_w64) version src;
  prePatch = ''
    cd mingw-w64-tools/gendef
  '';

  configureFlags = [
    "--with-tools=all"
  ];

  enableParallelBuilding = true;

  meta = {
    platforms = lib.platforms.unix;
  };
}
