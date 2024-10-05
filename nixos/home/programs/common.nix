{ pkgs, ... }:

{

  home.packages = with pkgs; [
    dconf
    wl-clipboard
    tree

    wofi
    alacritty
    swaybg

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

    slurp
    grim
    eza
    waybar

    webcord
    tidal-hifi
  ];
}
