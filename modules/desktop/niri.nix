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
{
  options.desktopEnvironment.niri.enable = mkEnableOption "Niri";
  config = mkIf cfg.enable {
    programs.niri.enable = true;
    display.greetd.enable = true;
    desktop.tilingWmBase.enable = true;
    desktop.standaloneGnomeSuite.enable = true;
    systemd.user.services.niri.enableDefaultPath = false;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
