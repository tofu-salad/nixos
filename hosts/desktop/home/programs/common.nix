{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    btop-rocm
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
