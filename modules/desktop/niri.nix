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
  display.greetd.enable = true;
  desktop.tilingWmBase.enable = true;
  desktop.standaloneGnomeSuite.enable = true;
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
