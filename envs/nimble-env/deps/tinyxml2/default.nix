{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/c326033c381ae71ed5a81cc07c6619017d4bfff4.tar.gz";
    sha256 = "1bpni1bnlj8v5d7277msv8yxcvggnmx7cfcl38l0pvz6nghs9pk3";
  }) {}
}:
with pkgs;
stdenv.mkDerivation rec {
  pname = "tinyxml2";
  version = "8.0.0";
  enableParallelBuilding = true;
  build-cores = 8;

  src = fetchgit {
    url = https://github.com/leethomason/tinyxml2;
    rev = "bf15233ad88390461f6ab0dbcf046cce643c5fcb";
    sha256 = "sha256-LWytjUfvC80VySHZdNQ6pKEVS+qKS0zlO/MpDUVGSmU=";
  };

  # dependencies
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];
}
