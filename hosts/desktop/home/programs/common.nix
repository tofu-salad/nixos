{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    btop-rocm
    eza
    fd
    ffmpeg
    fzf
    gh
    jq
    openssl
    ripgrep
    tmux
    tree
    unstable.neovim
  ];
}
