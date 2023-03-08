{ stdenv, pkgs }:
with pkgs;
let
  rev = "5fcdbba365286dddbe7df0dfec38c63610058f40";
in stdenv.mkDerivation rec{
  pname = "mumps";
  version = "5.5.1";

  srcs = [
    (fetchgit {
      url = "https://github.com/coin-or-tools/ThirdParty-Mumps";
      rev = "${rev}";
      sha256 = "sha256-NbZdH648KjBfb9Dbo0DlscEELwALsTneXvRntAqSeIo==";
    })
    (fetchTarball {
      url = "http://coin-or-tools.github.io/ThirdParty-Mumps/MUMPS_${version}.tar.gz";
      sha256 = "sha256:1vgjp9d199g07dbpmr76925nfdyfkxn05bdkzb864c5f162y0ar9";
    })
  ];

  sourceRoot = ".";

  # unpack
  postUnpack = ''
    mv ./ThirdParty-Mumps-${builtins.substring 0 7 rev}/* .
    mkdir MUMPS
    mv ./source/* MUMPS
  '';

  # patch
  patchPhase = ''
    patch -p0 < mumps_mpi.patch
    mv MUMPS/libseq/mpi.h MUMPS/libseq/mumps_mpi.h
  '';

  # configure
  # only need to set on mac
  preConfigure = if system == "aarch64-darwin" then ''
    export FC=$(which gfortran)
    echo "FC=$FC"
  '' else null;
  configureFlags = if system == "aarch64-darwin" then [
    "ADD_FCFLAGS=-fallow-argument-mismatch"
  ] else null;

  # install
  postInstall = ''
    ln -s $out/include/coin-or $out/include/coin
  '';

  # dependency
  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    lapack
    lapack-reference
    gfortran
  ];

}
