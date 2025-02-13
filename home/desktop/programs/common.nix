{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    dbus
    tree

    waybar
    wofi
    kitty
    swaybg

    neovim

    bat
    eza
    fd
    fzf
    jq
    tmux
    unzip


    openssl
    ripgrep

    slurp
    grim

  ];
}
