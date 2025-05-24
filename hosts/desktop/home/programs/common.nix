{ pkgs, ... }:
let
  ffmpeg-full-fixed =
    (pkgs.ffmpeg-full.override {
      withLcevcdec = false;
    }).overrideAttrs
      (
        finalAttrs: previousAttrs: {
          doCheck = false;
        }
      );
in
{
  home.packages = with pkgs; [
    btop-rocm
    bat
    eza
    fd
    fzf
    gh
    jq
    openssl
    ripgrep
    tmux
    ffmpeg-full-fixed
    tree
    unstable.neovim
    wezterm
  ];
}
