{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dbus
    kitty
    wofi
    neovim
    xdg-utils
    bat
    eza
    fd
    fzf
    jq
    openssl
    ripgrep
    tmux
    unzip
    wl-clipboard
  ];
}
