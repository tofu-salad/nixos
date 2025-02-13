{ pkgs, ... }:

{
  home.programs = with pkgs; [
    webcord
    mpv
    pamixer
    pavucontrol
    pulseaudio
    stremio
    swayimg
  ];
}
