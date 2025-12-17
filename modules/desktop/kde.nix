{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.kde;
in
mkIf cfg.enable {
  display.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    khelpcenter
    plasma-browser-integration
  ];
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
