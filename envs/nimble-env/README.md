# Environment to build nimble

This is an environment with all build dependencies of [nimble
v0.7.7](https://nimblephysics.org/).

When entering the environment via `nix-shell` for the first time, a python
virtual environment will be created at `~/.virtualenvs/nimble-nix`. This virtual
env will be activated when you enter this envrionment. The corresponding python
interpreter is from the nix store instead of your system. We need this virtual
environment because `nix` does not allow installing additional python packages
to `/nix/store`.
