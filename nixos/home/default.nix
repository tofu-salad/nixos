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
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
