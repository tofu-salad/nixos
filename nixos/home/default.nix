{ config, pkgs, ... }:

{
  imports = [ ./programs ./languages ];

  home = {
    username = "soda";
    homeDirectory = "/home/soda";
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
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
}
