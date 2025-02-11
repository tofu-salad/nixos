{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktopEnvironment.kde;
in {
  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      dolphin
      gwenview
      okular
      oxygen
      khelpcenter
      konsole
      plasma-browser-integration
      print-manager
    ];
  };
}
