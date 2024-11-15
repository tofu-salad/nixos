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
    pamixer
    pavucontrol
    stremio
    # obs-studio
  ];
}
