{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    tree
    bat
    fd
    fzf
    jq
    tmux
    unzip

    openssl
    ripgrep

    curl
    eza
    # turso-cli
    tmux

    # gcc
    neofetch

    adw-gtk3
    adwaita-qt
    adwaita-qt6
  ];
}
