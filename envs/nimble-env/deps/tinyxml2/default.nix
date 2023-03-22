{ stdenv, pkgs }:
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
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];
}
