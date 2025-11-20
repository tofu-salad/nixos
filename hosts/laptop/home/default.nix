{ pkgs, ... }:

{
  home.username = "tofu";
  fonts.fontconfig.enable = true;

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
        name = "alacritty terminal";
        command = "alacritty";
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
    firefox
    alacritty
    google-chrome
    libreoffice
    qbittorrent
    stremio
    vlc
  ];

  programs.git = {
    enable = true;
    userName = "tofu-salad";
    userEmail = "67925799+tofu-salad@users.noreply.github.com";
    extraConfig = {
      color.ui = "auto";
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
