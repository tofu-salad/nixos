{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.desktop.mangowc;
in
{
  options.desktop.mangowc.enable = mkEnableOption "MangoWC";
  config = mkIf cfg.enable {
    display.greetd.enable = true;
    desktop.tilingWmBase.enable = true;
    desktop.standaloneGnomeSuite.enable = true;

    programs.mangowc.enable = true;
    programs = {
      uwsm.enable = true;
      uwsm.waylandCompositors.mangowc = {
        prettyName = "MangoWC";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };
  };
}
