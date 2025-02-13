{ config, pkgs, ... }:

{
  imports = [ ./programs ];

  home = {
    username = "tofu";
    homeDirectory = "/home/tofu";
  };
  fonts.fontconfig.enable = true;
  fonts.fontconfig.subpixel.lcdfilter = "light";
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "IBMPlexMono"
        "GeistMono"
      ];
    })
  ];
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
