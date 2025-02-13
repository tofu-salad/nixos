{ pkgs, ... }:

{
  home.packages = with pkgs; [
    webcord
    mpv
    pamixer
    pavucontrol
    pulseaudio
    stremio
    swayimg
  ];
}
