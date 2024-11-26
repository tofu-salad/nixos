{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
    ];
  };

  home.packages = with pkgs; [
    gimp
    transmission_4 # torrent app
    stremio
    tidal-hifi
    webcord
  ];
}
