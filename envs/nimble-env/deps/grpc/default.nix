{ pkgs ? import <nixpkgs> {}, stdenv ? (import <nixpkgs> {}).stdenv }:
with pkgs;
let
  grpc-rev = "11f00485aa5ad422cfe2d9d90589158f46954101";
  protobuf-rev = "2514f0bd7da7e2af1bed4c5d1b84f031c4d12c10";
in stdenv.mkDerivation rec{
  pname = "grpc-protobuf_3_14_0";
  version = "1.42.0";
  enableParallelBuilding = true;
  build-cores = 8;

  srcs = [
    (fetchgit {
      url = https://github.com/grpc/grpc;
      rev = "${grpc-rev}";
      sha256 = "sha256-9/ywbnvd8hqeblFe+X9SM6PkRPB/yqE8Iw9TNmLMSOE=";
      fetchSubmodules = true;
    })
    (fetchgit {
      url = https://github.com/protocolbuffers/protobuf;
      rev = "${protobuf-rev}";
      sha256 = "sha256-fp4DQm7JqKHkmlv7rSYNTazhuMmmU3oyheSDSyC35E8=";
      fetchSubmodules = true;
    })
  ];

  sourceRoot = ".";

  # unpack
  postUnpack = ''
    rm -rf ./grpc-${builtins.substring 0 7 grpc-rev}/third_party/protobuf
    mkdir ./grpc-${builtins.substring 0 7 grpc-rev}/third_party/protobuf
    mv ./protobuf-${builtins.substring 0 7 protobuf-rev}/* ./grpc-${builtins.substring 0 7 grpc-rev}/third_party/protobuf
    cd ./grpc-${builtins.substring 0 7 grpc-rev}/
  '';

  # configure
  preConfigure = ''
    rm BUILD
  '';

  # dependency
  buildInputs = [ cmake ];
  cmakeFlags = [
    "-DgRPC_INSTALL=ON"
    "-DgRPC_BUILD_TESTS=OFF"
    "-DCMAKE_CXX_FLAGS=\"-Wno-format-security\""
    (if pkgs.system == "aarch64-darwin"
     then "-DCMAKE_CXX_FLAGS=\"-fvisibility=hidden\""
     else null)
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_BINDIR=bin"
  ];
}
