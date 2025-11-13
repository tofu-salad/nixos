{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./browsers.nix
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

  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "adw-gtk3";
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.dash-to-dock.extensionUuid
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "ghostty terminal";
        command = "ghostty";
        binding = "<Super>Return";
      };
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.sessionVariables = {
    GSK_RENDERER = "ngl";
  };
  home.packages = with pkgs; [
    ghostty
    adw-gtk3
    libreoffice
    qbittorrent
    stremio
    vlc
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
