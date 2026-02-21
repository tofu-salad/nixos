{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.hyprland;
  breezeDarkQt5ct = pkgs.writeText "breeze-dark.conf" ''
    [ColorScheme]
    active_colors=#fffcfcfc, #ff292c3c, #ff454a52, #ff3a3d47, #ff1a1d22, #ff232630, #fffcfcfc, #fffcfcfc, #fffcfcfc, #ff141618, #ff202226, #ff0a0b0d, #ff3daee9, #fffcfcfc, #ff1d99f3, #ff9b59b6, #ff1d2026, #fffcfcfc, #ff292c3c, #fffcfcfc, #80a1a9b1, #ff3daee9
    inactive_colors=#ffa1a9b1, #ff1e2026, #ff454a52, #ff3a3d47, #ff1a1d22, #ff232630, #ffa1a9b1, #fffcfcfc, #ffa1a9b1, #ff141618, #ff202226, #ff0a0b0d, #ff292c3c, #ffa1a9b1, #ffa1a9b1, #ffa1a9b1, #ff1d2026, #fffcfcfc, #ff292c3c, #fffcfcfc, #80a1a9b1, #ff292c3c
    disabled_colors=#ff606873, #ff292c3c, #ff454a52, #ff3a3d47, #ff1a1d22, #ff232630, #ff606873, #fffcfcfc, #ff606873, #ff141618, #ff202226, #ff0a0b0d, #ff202226, #ff606873, #ff7ca0bc, #ffb0a0c0, #ff1d2026, #fffcfcfc, #ff292c3c, #fffcfcfc, #80a1a9b1, #ff202226
  '';
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
  };

  systemd.tmpfiles.rules = [
    "d /home/tofu/.config/qt5ct 0755 tofu users -"
    "d /home/tofu/.config/qt5ct/colors 0755 tofu users -"
    "L+ /home/tofu/.config/qt5ct/colors/breeze-dark.conf - - - - ${breezeDarkQt5ct}"
    "d /home/tofu/.config/qt6ct 0755 tofu users -"
    "d /home/tofu/.config/qt6ct/colors 0755 tofu users -"
    "L+ /home/tofu/.config/qt6ct/colors/breeze-dark.conf - - - - ${breezeDarkQt5ct}"
  ];

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
    kdePackages.breeze
  ];
}
