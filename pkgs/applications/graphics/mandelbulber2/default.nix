{ lib, mkDerivation, fetchFromGitHub, libpng, gsl, libsndfile, lzo,
qmake, qttools, qtbase, qtmultimedia,
opencl ? true, opencl-clhpp ? null, ocl-icd ? null }:

assert opencl -> opencl-clhpp != null;
assert opencl -> ocl-icd != null;

mkDerivation rec {
  pname = "mandelbulber2";
  version = "2.19";

  src = fetchFromGitHub {
    owner = "buddhi1980";
    repo = "mandelbulber2";
    rev = version;
    sha256 = "10kq30mxryq78kgsrqwpmws4knz7yfzhdq4zhl28rrz2k1bydgij";
  };

  patches = [ ./0001-use-SHARED_DIR.patch ];
  patchFlags = [ "-p2" ]; # Because of sourceRoot

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtmultimedia libpng gsl libsndfile lzo ] ++
    lib.optionals opencl [ opencl-clhpp ocl-icd ];

  sourceRoot = "source/mandelbulber2";

  qmakeFlags = [ "SHARED_PATH=${placeholder ''out''}"
                 (if opencl
                  then "qmake/mandelbulber-opencl.pro"
                  else "qmake/mandelbulber.pro") ];

  meta = with lib; {
    description = "A 3D fractal rendering engine";
    longDescription = "Mandelbulber creatively generates three-dimensional fractals. Explore trigonometric, hyper-complex, Mandelbox, IFS, and many other 3D fractals.";
    homepage = "https://mandelbulber.com";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kovirobi ];
  };
}
