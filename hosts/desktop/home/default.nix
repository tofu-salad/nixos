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
    style.name = "adwaita-dark";
  };
  gtk = {
    enable = true;
    font = {
      name = "Adwaita Sans";
      size = 12;
    };
    theme = {
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
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
  home.packages = with pkgs; [
    adw-gtk3
  ];

  xdg.desktopEntries = {
    nemo = {
      name = "Files";
      comment = "Access and organize files";
      exec = "nemo %U";
      startupNotify = false;
      icon = "nemo";
      type = "Application";
      terminal = false;
      categories = [
        "GNOME"
        "GTK"
        "Utility"
        "Core"
      ];
      mimeType = [
        "inode/directory"
        "application/x-gnome-saved-search"
      ];
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
