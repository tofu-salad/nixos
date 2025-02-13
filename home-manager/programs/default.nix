{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./common.nix
    ./zsh.nix
  ];
}
