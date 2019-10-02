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

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtmultimedia libpng gsl libsndfile lzo ] ++
    lib.optionals opencl [ opencl-clhpp ocl-icd ];

  sourceRoot = "source/mandelbulber2";

  qmakeFlags = [ "DEFINES+=SHARED_PATH=${placeholder ''out''}"
                 (if opencl
                  then "qmake/mandelbulber-opencl.pro"
                  else "qmake/mandelbulber.pro")
                  ];

  postFixup = ''
    for f in \
        "$out/share/mandelbulber2/examples/gradients - reflectance and transparency.fract" \
        "$out/share/mandelbulber2/examples/gradients - specular highlights.fract" \
        "$out/share/mandelbulber2/examples/transparency reflectance roughness textures.fract" \
        "$out/share/mandelbulber2/examples/Sebastian Jennen collection - license Creative Commons  (CC-BY 4.0)/aexion blue-sky-two-suns.fract" \
        "$out/share/mandelbulber2/examples/Krzysztof Marczak collection - license Creative Commons (CC-BY 4.0)/Construct by Ectoplaz 2.fract" \
        "$out/share/mandelbulber2/data/mandelbulber_1.21_defaults.fract" \
        "$out/share/doc/mandelbulber2/NEWS"; do
      substituteInPlace "$f" --replace "/usr" "$out"
    done
  '';

  meta = with lib; {
    description = "A 3D fractal rendering engine";
    longDescription = "Mandelbulber creatively generates three-dimensional fractals. Explore trigonometric, hyper-complex, Mandelbox, IFS, and many other 3D fractals.";
    homepage = "https://mandelbulber.com";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kovirobi ];
  };
}
