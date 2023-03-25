{ stdenv, pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "assimp";
  version = "5.0.1";
  enableParallelBuilding = true;
  build-cores = 8;

  src = fetchgit {
    url = https://github.com/assimp/assimp;
    rev =  "8f0c6b04b2257a520aaab38421b2e090204b69df";
    sha256 = "sha256-cGLOZlfNjkPHlWjNboU20mmKTu/Hnd7ebC1xDwa3i2M=";
  };

  # dependency
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DASSIMP_BUILD_ZLIB=ON"
    "-DASSIMP_BUILD_TESTS=ON"
    "-DASSIMP_BUILD_ASSIMP_TOOLS=OFF"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];
}
