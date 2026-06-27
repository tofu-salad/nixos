{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.sway;
in
{
  options.desktop.sway.enable = mkEnableOption "Sway";
  config = mkIf cfg.enable {
    display.greetd.enable = true;
    desktop.tilingWmBase.enable = true;
    desktop.standaloneGnomeSuite.enable = true;

    programs = {
      uwsm.enable = true;

      uwsm.waylandCompositors.sway = {
        prettyName = "Sway";
        binPath = "/run/current-system/sw/bin/sway";
      };

      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
          brightnessctl
        ];
      };
    };
  };
}
