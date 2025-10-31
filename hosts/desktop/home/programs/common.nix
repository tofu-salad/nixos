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

    # nvim+dependencies
    unstable.neovim
    luajitPackages.luarocks
    lua51Packages.lua
    tree-sitter
  ];
}
