let
  callPackage = (import <nixpkgs> {}).callPackage;
in rec {
  nimble-env = callPackage ./envs/nimble-env {};
}
