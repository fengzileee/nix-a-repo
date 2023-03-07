{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/c326033c381ae71ed5a81cc07c6619017d4bfff4.tar.gz";
    sha256 = "1bpni1bnlj8v5d7277msv8yxcvggnmx7cfcl38l0pvz6nghs9pk3";
  }) {}
}:
let
  python = pkgs.python38;
  my_py_pkgs = {
    delocate= python.pkgs.buildPythonPackage rec {
      pname = "delocate";
      version = "0.10.4";
      src = python.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-6ucS9G8jSBrIIlC53DVygLjNF6wOV9zghlTV9yJ5PJM=";
      };
      doCheck = false;
      meta = {
        homepage = "https://github.com/matthew-brett/delocate";
        description = "Find and copy needed dynamic libraries into python wheels";
      };
      propagatedBuildInputs = with python.pkgs; [typing-extensions packaging];
    };
  };
  pythonEnv = python.withPackages (ps: with ps; [
    pytest
    numpy
    packaging
    my_py_pkgs.delocate
    ipython
    setuptools
    wheel
  ]);
in pkgs.mkShell {
  buildInputs = with pkgs; [
    which
    cmake
    assimp
    boost
    gfortran
    gcc
    eigen
    pkgconfig
    libccd
    openssl
    lapack-reference
    console-bridge
    urdfdom
    urdfdom-headers
    libxcrypt
    (callPackage deps/mumps {})
    (callPackage deps/ipopt {})
    (callPackage deps/tinyxml {})
    (callPackage deps/tinyxml2 {})
    (callPackage deps/ezc3d {})
    (callPackage deps/grpc {})
    python.pkgs.pybind11
    gbenchmark
    gtest
    pythonEnv
    unzip
  ];

  # HACK: for codesign on mac
  shellHook = if pkgs.system == "aarch64-darwin" then ''
    export PATH=$PATH:/usr/bin/
  '' else "";
}
