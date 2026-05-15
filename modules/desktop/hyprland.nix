{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.desktopEnvironment.hyprland;
in
{
  options.desktopEnvironment.hyprland.enable = mkEnableOption "Hyprland";

  config = mkIf cfg.enable {
    display.greetd.enable = true;
    desktop.tilingWmBase.enable = true;
    desktop.standaloneGnomeSuite.enable = true;
    programs.hyprland = {
      withUWSM = true;
      enable = true;
    };
    xdg = {
      portal = {
        enable = true;
        config = {
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          };
        };
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      };
    };
  };
}
