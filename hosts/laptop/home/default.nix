{ pkgs, ... }:
{
  imports = [
    ./chromium.nix
    ./git.nix
  ];
  home = {
    username = "tofu";
    pointerCursor = {
      gtk.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Inter Variable";
      package = pkgs.inter;
      size = 12;
    };
  };

  dconf = {
    enable = true;
  };

  fonts.fontconfig.enable = true;
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
