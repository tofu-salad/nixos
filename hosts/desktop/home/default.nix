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

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "breeze";
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
  };
  dconf = {
    enable = true;
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "foot";
      };
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
