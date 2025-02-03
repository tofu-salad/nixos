{ pkgs, ... }:

{
  imports = [
    ./programs
    ./languages
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
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
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
