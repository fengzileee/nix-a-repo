{}:
let
  pkgs = import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/c326033c381ae71ed5a81cc07c6619017d4bfff4.tar.gz";
      sha256 = "1bpni1bnlj8v5d7277msv8yxcvggnmx7cfcl38l0pvz6nghs9pk3";
    }) {};
  python = pkgs.python38;
  my_py_pkgs =
    rec {
      delocate = (
        if pkgs.system == "aarch64-darwin" then
          python.pkgs.buildPythonPackage
            rec {
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
            }
        else null
      );
      auditwheel = (
        if pkgs.system == "x86_64-linux" then
          python.pkgs.buildPythonPackage rec {
            pname = "auditwheel";
            version = "5.1.2";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-PuWDABSTHqhK9c0GXGN7ZhTvoD2biL2Pv8kk5+0B1ro=";
            };
            doCheck = false;
            meta = {
              homepage = "https://github.com/pypa/auditwheel";
              description = "Auditing and relabeling cross-distribution Linux wheels.";
            };
            propagatedBuildInputs = with python.pkgs; [ pyelftools ];
          }
        else null
      );
    };
  pythonEnv = python.withPackages (ps: with ps; [
    pip
    virtualenv
    pytest
    numpy
    my_py_pkgs.delocate
    my_py_pkgs.auditwheel
    ipython
    setuptools
    wheel
  ]);
  stdenv = if pkgs.system == "aarch64-darwin" then pkgs.stdenv
           else pkgs.gcc9Stdenv;
in stdenv.mkDerivation {
  name = "nimble-env";
  buildInputs = with pkgs; [
    which
    cmake
    (if pkgs.system == "aarch64-darwin" then assimp
     else (callPackage deps/assimp { pkgs = pkgs; stdenv = stdenv; }))
    (boost165.override { inherit stdenv; })
    (callPackage deps/eigen { pkgs = pkgs; stdenv = stdenv; })
    pkgconfig
    openssl
    console-bridge
    urdfdom
    urdfdom-headers
    (if pkgs.system == "aarch64-darwin" then libccd
     else (callPackage deps/libccd { pkgs = pkgs; stdenv = stdenv; }))
    libxcrypt
    (callPackage deps/mumps { pkgs = pkgs; stdenv = stdenv; })
    (callPackage deps/ipopt { pkgs = pkgs; stdenv = stdenv; })
    (callPackage deps/tinyxml { pkgs = pkgs; stdenv = stdenv; })
    (callPackage deps/tinyxml2 { pkgs = pkgs; stdenv = stdenv; })
    (callPackage deps/ezc3d { pkgs = pkgs; stdenv = stdenv; })
    (callPackage deps/grpc { pkgs = pkgs; stdenv = stdenv; })
    python.pkgs.pybind11
    gbenchmark
    gtest
    pythonEnv
    unzip
  ];

  # HACK: for codesign on mac
  shellHook = if pkgs.system == "aarch64-darwin" then ''
    export PATH=$PATH:/usr/bin/
  '' else ''
    if ! [ -d ~/.virtualenvs/nimble-nix ]; then
      if ! [ -d ~/.virtualenvs/ ]; then
        mkdir ~/.virtualenvs
      fi
      python -m venv ~/.virtualenvs/nimble-nix
    fi
    . ~/.virtualenvs/nimble-nix/bin/activate
  '';
}
