{ stdenv, pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "tinyxml";
  version = "0.0.0";
  enableParallelBuilding = true;
  build-cores = 8;

  src = fetchgit {
    url = https://github.com/robotology-dependencies/tinyxml;
    rev = "f83a543bb42d3c75be3b7c1f9f74e1f8d5e6f86a";
    sha256 = "sha256-0RX7cI/xoLpBI2Awa83MmUv2ubKM52rGfjosRmWX0dI=";
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
