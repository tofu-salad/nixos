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
      extraPackages = with pkgs; [ fuzzel ];
    };
    desktop.standaloneGnomeSuite.enable = true;

    programs = {
      uwsm.enable = true;
      uwsm.waylandCompositors.mango = {
        prettyName = "mango";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };

    xdg.portal.wlr.settings.screencast = {
      chooser_type = "dmenu";
      chooser_cmd = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.fuzzel}/bin/fuzzel --dmenu";
    };
    xdg.portal = {
      enable = true;
      config = {
        mango = {
          default = [
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];

          "org.freedesktop.impl.portal.Inhibit" = [ ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };

    programs.mango.enable = true;
  };
}
