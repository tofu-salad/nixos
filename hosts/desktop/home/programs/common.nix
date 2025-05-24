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
  rsmiGpuBtop = pkgs.btop.overrideAttrs (
    finalAttrs: previousAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "aristocratos";
        repo = "btop";
        rev = "2e7208d59c54515080027a5ecbb89d2054047985";
        hash = "sha256-4OQRdddCb8+/ReYwGduf2LytlMt0Cv4ldF/rI/Nkx+k=";
      };
    }
  );
in
{
  home.packages = with pkgs; [
    (rsmiGpuBtop.override { rocmSupport = true; })
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
