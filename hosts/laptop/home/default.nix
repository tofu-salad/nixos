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

  gtk = {
    enable = true;
    font = {
      name = "Adwaita Sans";
      size = 12;
    };
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
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "alacritty terminal";
        command = "alacritty";
        binding = "<Super>Return";
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

  home.packages = with pkgs; [
    adw-gtk3
    alacritty
    libreoffice
    qbittorrent
    stremio
    vlc
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
