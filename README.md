# Some Nix expressions

This is a repo storing my [Nix](https://nixos.org/) expressions.

## If you never used nix before

### Install nix

You need to [install nix](https://nixos.org/download.html). You might need to run
``` sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
```
after installation.

### Get an environment

Clone this repo to your computer, e.g., `~/nix-a-repo`.

To get an environment, run `nix-shell ~/nix-a-repo -A <env-name>`. For example,
to get an environment to build and use `nimble`, run

``` sh
nix-shell ~/nix-a-repo -A nimble-env
```

The available environments and packages are listed [here](./envs). I follow the
convention that an environment (i.e., not intended for `nix-build`) ends with
`-env`.

To exit a nix-shell, use command `exit` or press `CTRL-D`.
