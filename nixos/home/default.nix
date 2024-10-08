{ pkgs-70eb14712, pkgs, ... }:

{
  imports = [
    ./programs
    ./languages
  ];

  home = {
    username = "tofu";
    pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 32;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs-70eb14712.adw-gtk3;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = "1";
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
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
