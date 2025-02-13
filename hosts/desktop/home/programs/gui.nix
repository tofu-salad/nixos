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
    qbittorrent
    stremio
    tidal-hifi
    discord-canary
  ];
}
