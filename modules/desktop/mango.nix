{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.mango;
in
{
  imports = [
    inputs.mango.nixosModules.mango
  ];

  config = mkIf cfg.enable {
    display.greetd.enable = true;
    desktop.tilingWmBase = {
      enable = true;
      extraPackages = with pkgs; [ wofi ];
    };
    desktop.standaloneGnomeSuite.enable = true;

    programs = {
      uwsm.enable = true;
      uwsm.waylandCompositors.mango = {
        prettyName = "mango";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };

    xdg.portal.config.mango = {
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    xdg.portal.wlr.settings.screencast = {
      chooser_type = "dmenu";
      chooser_cmd = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.wofi}/bin/wofi --dmenu --hide-search --width 300 --height 125";
    };

    programs.mango.enable = true;
  };
}
