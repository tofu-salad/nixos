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
    obs-studio
    pamixer
    pavucontrol
    stremio
  ];
}
