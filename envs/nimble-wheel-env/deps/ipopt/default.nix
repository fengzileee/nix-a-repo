{ stdenv, pkgs }:
with pkgs;
let
  rev = "332132a4ab18e53153d85fd637880babf1d7ff03";
in stdenv.mkDerivation rec {
  pname = "ipopt";
  version = "3.14.11";
  enableParallelBuilding = true;
  build-cores = 8;

  src = fetchgit {
    url = "https://github.com/coin-or/Ipopt";
    rev = "${rev}";
    sha256 = "sha256-+H2KLSmWP8sjo0KGdHYdfdyh58VrvQH3Qbhie8wGYYQ=";
  };

  # configure
  configureFlags = [
    "--with-mumps"
    "--disable-java"
  ];

  # install
  postInstall = ''
    ln -s $out/include/coin-or $out/include/coin
  '';

  # dependency
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    (callPackage ../mumps {})
    lapack
    lapack-reference
  ];
}
