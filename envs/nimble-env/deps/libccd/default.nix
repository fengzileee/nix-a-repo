{ stdenv, pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "libccd";
  version = "2.1";
  enableParallelBuilding = true;
  build-cores = 8;

  src = fetchgit {
    url = https://github.com/danfis/libccd;
    rev =  "7931e764a19ef6b21b443376c699bbc9c6d4fba8";
    sha256 = "sha256-TIZkmqQXa0+bSWpqffIgaBela0/INNsX9LPM026x1Wk=";
  };


  # dependency
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DENABLE_DOUBLE_PRECISION=ON"
    (if system == "x86_64-linux" then
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
     else null)
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];
}
