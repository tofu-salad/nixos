{ pkgs, ... }:

{
  home.packages = with pkgs; [
    glib
    kitty
    neovim
    xdg-utils
    krita
    bat
    exa
    fd
    fzf
    jq
    openssl
    ripgrep
    tmux
    trash-cli
    udev
    unzip
    wl-clipboard
  ];
}
