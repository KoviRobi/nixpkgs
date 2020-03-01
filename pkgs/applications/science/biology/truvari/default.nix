{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonApplication
, pyvcf
, python-Levenshtein
, progressbar2
, pysam
, pyfaidx
, intervaltree
}:

buildPythonApplication rec {
  pname = "truvari";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "spiralgenetics";
    repo = "truvari";
    rev = "v${version}";
    sha256 = "1bph7v48s7pyfagz8a2fzl5fycjliqzn5lcbv3m2bp2ih1f1gd1v";
  };

  patches = [
    (fetchpatch { # This can be removed version 1.3.5 onwards
      url = "https://github.com/spiralgenetics/truvari/commit/5edfe155ff97b1c1fc54f31f33a3de495b87aede.patch";
      sha256 = "09nrvy1c0fb7cknsd7r22j476szwxrh9nbjj82frhld3jj3k3393";
    })
  ];

  propagatedBuildInputs = [
    pyvcf
    python-Levenshtein
    progressbar2
    pysam
    pyfaidx
    intervaltree
  ];

  meta = with lib; {
    description = "Structural variant comparison tool for VCFs";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
    longDescription = ''
      Truvari is a benchmarking tool for comparison sets of SVs.
      It can calculate the recall, precision, and f-measure of a
      vcf from a given structural variant caller. The tool
      is created by Spiral Genetics.
    '';
  };
}
