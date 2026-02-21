{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.hyprland;
in
mkIf cfg.enable {
  display.greetd.enable = true;
  desktop.tilingWmBase = {
    enable = true;
    extraPackages = [ ];
  };
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

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "breeze";
  };

  environment.systemPackages = with pkgs; [
    unstable.noctalia-shell
    hyprpolkitagent
  ];
}
