
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dconf
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
  ];
}
