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
      name = "Inter Variable";
      package = pkgs.inter;
      size = 12;
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
        name = "foot terminal";
        command = "foot";
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
    adwaita-icon-theme
    foot
    gsettings-desktop-schemas
    libreoffice-qt
    qbittorrent
    stremio
    vlc
    wl-clipboard
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
