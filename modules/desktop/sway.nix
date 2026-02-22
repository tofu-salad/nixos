{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.sway;
in
mkIf cfg.enable {
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
        swaylock
      ];
    };
  };

  xdg = {
    portal = {
      enable = true;
      config = {
        sway = {
          default = lib.mkForce [ "gnome" ];
        };
      };
      wlr = {
        enable = true;
        settings = {
          screencast = {
            chooser_type = "dmenu";
            chooser_cmd = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.fuzzel}/bin/fuzzel --dmenu --no-exit-on-keyboard-focus-loss";
          };
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
