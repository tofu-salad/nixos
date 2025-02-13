{ config, pkgs, ... }:

{
  imports = [ ./programs ./languages ];

  home = {
    username = "soda";
    homeDirectory = "/home/soda";
    pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 32;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
