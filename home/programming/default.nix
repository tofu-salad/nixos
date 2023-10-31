{ config, pkgs, ... }: {
  imports = [
    ./c.nix
    # ./go.nix
    # ./java.nix
    # ./javascript.nix
    # ./lua.nix
    ./nix.nix
    # ./python.nix
    # ./rust.nix
    ./shell.nix
  ];
}
