{ pkgs, ... }:

{
  home.packages = with pkgs; [
    webcord
    gimp
    vlc
    obs-studio
    pamixer
    pavucontrol
    stremio

    zathura
  ];
}
