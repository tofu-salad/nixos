{ pkgs, pkgs-unstable, ... }:

{
  home.packages = (with pkgs; [
    wl-clipboard
    tree

    waybar
    wofi
    kitty
    swaybg

    neovim

    bat
    fd
    fzf
    jq
    tmux
    unzip


    openssl
    ripgrep

    slurp
    grim
    direnv
  ]) ++ (with pkgs-unstable;[
    eza
    turso-cli
  ]);
}
