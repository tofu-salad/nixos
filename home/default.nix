{ config, pkgs, ... }:

{
  imports = [ ./programming ./programs ];

  home = {
    username = "dezequiel";
    homeDirectory = "/home/dezequiel";
    pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 32;
    };
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
}
