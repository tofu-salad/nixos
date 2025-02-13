{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    vlc
    obs-studio
    pamixer
    pavucontrol
    stremio
  ];
}
