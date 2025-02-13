{ config, pkgs, ... }:

{
  imports = [ ./programs ];

  home = {
    username = "soda";
    homeDirectory = "/home/soda";
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
