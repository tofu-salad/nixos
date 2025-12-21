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
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
    khelpcenter
    konsole
    plasma-browser-integration
  ];
  environment.systemPackages = with pkgs; [
    alacritty
    wl-clipboard
  ];
}
