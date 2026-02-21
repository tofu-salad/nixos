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

  systemd.user.services.mate-policykit-agent-1 = {
    enable = true;
    description = "mate-policykit-agent-1";
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.systemPackages = with pkgs; [
    unstable.noctalia-shell
  ];
}
