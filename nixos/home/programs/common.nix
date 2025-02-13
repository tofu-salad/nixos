{ pkgs, ... }:

let
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
    dconf
    wl-clipboard
    tree
    (rsmiGpuBtop.override { rocmSupport = true; })

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
