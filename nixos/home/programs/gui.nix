{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    qbittorrent
    stremio
    tidal-hifi
    webcord
  ];
}
