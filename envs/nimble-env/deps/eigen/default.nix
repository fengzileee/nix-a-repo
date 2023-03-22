{ pkgs, stdenv }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "eigen";
  version = "3.4.0";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = pname;
    rev = version;
    sha256 = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
  };

  patches = [
    ./include-dir.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
  };
}
