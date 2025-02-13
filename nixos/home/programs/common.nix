{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dconf
    wl-clipboard
    tree


    wofi
    kitty
    wezterm
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
    turso-cli
    adw-gtk3
  ];
}
