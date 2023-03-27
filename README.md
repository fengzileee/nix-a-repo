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

### Install nix without root (e.g., on the server)

Using `nix-user-chroot`. See [https://github.com/nix-community/nix-user-chroot].

Check if the kernel supports this:

``` sh
unshare --user --pid echo YES
```

The output should be =YES=.

Install =nix-user-chroot= by downloading the binary:

``` sh
wget https://github.com/nix-community/nix-user-chroot/releases/download/1.2.2/nix-user-chroot-bin-1.2.2-x86_64-unknown-linux-musl
chmod +x <the binary>
```

And put it into your `PATH`.

Then

``` sh
mkdir -m 0755 ~/.nix
nix-user-chroot ~/.nix bash -c "curl -L https://nixos.org/nix/install | bash"
```

Afterwards, add `nix-user-chroot ~/.nix bash -l` to `~/.profile` *after* the nix
profile sourcing line (added by the `nix` installer).

``` sh
if [ -z "$NIX_PROFILES" ]; then PS1="[no-nix]$PS1"; fi
if [ -z "${NIX_PROFILES}" ]; then nix-user-chroot $HOME/.nix bash -l; fi
```

Or, add the following after the nix profile sourcing line to manually activate nix

``` sh
if ! [ -z "$NIX_PROFILES" ]; then PS1="[nix]$PS1"; fi
activate-nix () {
    nix-user-chroot $HOME/.nix bash -l
}
```

### Get an environment via nix-shell

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
