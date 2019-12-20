{ stdenv
, lib
, fetchgit
, libbsd
# , lua
# , cjson # lua cjson TODO: Using bundled?
# , lua-readline TODO: add
# , argparse # lua argparse
, readline
}:

stdenv.mkDerivation rec {
  pname = "rosie";
  version = "1.2.1";
  src = fetchgit {
    url = https://gitlab.com/rosie-pattern-language/rosie;
    rev = "v${version}";
    sha256 = "1fgp48q9xn8fc4zbpyc2issmmc6lrdsxpa93nk3xaj0qcj6kgz78";
    fetchSubmodules = true;
  };

  postUnpack = ''
      touch ${src.name}/submodules/~~present~~
    '';

  preConfigure = ''
    patchShebangs src/build_info.sh
    ln -s src submodules/lua/include
    substituteInPlace Makefile \
      --replace 'DESTDIR=/usr/local' "DESTDIR=$out"
  '';

  postInstall = ''
    rm $out/lib/rosie/build.log
    mkdir -p $out/share/emacs/site-lisp $out/share/vim $out/share/nvim
    mv $out/lib/rosie/extra/extra/emacs/* $out/share/emacs/site-lisp/
    mv $out/lib/rosie/extra/extra/vim $out/share/vim/site
    ln -s $out/share/vim/site $out/share/nvim/site
  '';

  buildInputs = [ libbsd readline ];

  meta = with lib; {
    website = https://rosie-lang.org;
    description = "Tools for searching using parsing expression grammars";
    longDescription = "";
    license = licenses.mit;
    maintainers = with maintainers; [ kovirobi ];
  };
}
