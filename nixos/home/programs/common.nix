{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    tree


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
    eza
    waybar
    turso-cli
  ];
}
