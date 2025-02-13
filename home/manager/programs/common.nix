{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    wget
    curl
    eza
    fd
    fzf
    jq
    ripgrep
    tmux
    unzip
    wl-clipboard
  ];
}
