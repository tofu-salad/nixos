{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.niri;
in
mkIf cfg.enable {
  display.sddm.enable = true;
  desktop.tilingWmBase.enable = true;
  desktop.standaloneGnomeSuite.enable = true;
  security.polkit.enable = true;
  programs.niri.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];
}
