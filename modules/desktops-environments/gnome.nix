{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.gnome;
in
{
  config = mkIf cfg.enable {
    services.xserver = {
      desktopManager.gnome.enable = true;
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-maps
      gnome-connections
      gnome-software
      gnome-music
      gnome-contacts
      gnome-console
      totem
      epiphany
      geary
      snapshot
    ];
    environment.systemPackages = (
      with pkgs.gnomeExtensions;
      [
        dash-to-dock
        openweather-refined
        tailscale-status
        appindicator
      ]
    );
  };
}
