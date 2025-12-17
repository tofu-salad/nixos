{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.standaloneGnomeSuite;
in
{
  options.desktop.standaloneGnomeSuite = {
    enable = mkEnableOption "standalone gnome application + gtk plumbing";

    enableLocalsearch = mkOption {
      type = types.bool;
      default = true;
      description = "enable gnome tracker / localsearch";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      baobab
      file-roller
      loupe
      papers

      gnome-calculator
      gnome-characters
      gnome-font-viewer
      gnome-text-editor

      adwaita-fonts
      adwaita-icon-theme
      adwaita-icon-theme-legacy
    ];

    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
    services.gnome.gnome-keyring.enable = true;
    services.gnome.localsearch.enable = cfg.enableLocalsearch;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
