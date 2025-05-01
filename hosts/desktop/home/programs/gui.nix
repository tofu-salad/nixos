{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
    ];
  };

  home.packages = with pkgs; [
    unstable.gimp3
    qbittorrent
    stremio
    tidal-hifi
    discord-canary
  ];
}
