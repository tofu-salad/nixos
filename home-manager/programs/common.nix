
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tree

    neovim

    bat
    fd
    fzf
    jq
    tmux
    unzip
    gh

    openssl
    ripgrep

    curl
    eza
    turso-cli
    tmux

    nodejs_20
    gcc
    neofetch
  ];
}
