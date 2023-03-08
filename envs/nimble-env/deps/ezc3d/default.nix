{ stdenv, pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "ezc3d";
  version = "1.4.7";
  enableParallelBuilding = true;
  build-cores = 8;

  src = fetchgit {
    url = https://github.com/pyomeca/ezc3d;
    rev =  "0d3198586ba84d6799e11a6b12742b5596a11c90";
    sha256 = "sha256-cBqqFIiC1Jj2voKa6+mB3agFsC+UlspIHS18EEELWtQ=";
  };

  # install
  postInstall = ''
    ln -s $out/lib/ezc3d/libezc3d.dylib $out/lib/libezc3d.dylib
  '';

  # dependency
  nativeBuildInputs = [
    cmake
  ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];
}
