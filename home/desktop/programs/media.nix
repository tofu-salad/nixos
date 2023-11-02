{ pkgs, ... }:

{
  home.packages = with pkgs; [
    webcord
    vlc
    obs-studio
    pamixer
    pavucontrol
    stremio

    zathura
  ];
}
