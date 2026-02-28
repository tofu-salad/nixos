{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.desktop.tilingWmBase or { enable = false; };

  users = config.users.users or { };

  normalUsers = builtins.filter (name: users.${name}.isNormalUser or false) (
    builtins.attrNames users
  );

  breezeDarkQt5ct = pkgs.writeText "breeze-dark.conf" ''
    [ColorScheme]
    active_colors=#fffcfcfc, #ff292c3c, #ff454a52, #ff3a3d47, #ff1a1d22, #ff232630, #fffcfcfc, #fffcfcfc, #fffcfcfc, #ff141618, #ff202226, #ff0a0b0d, #ff3daee9, #fffcfcfc, #ff1d99f3, #ff9b59b6, #ff1d2026, #fffcfcfc, #ff292c3c, #fffcfcfc, #80a1a9b1, #ff3daee9
    inactive_colors=#ffa1a9b1, #ff1e2026, #ff454a52, #ff3a3d47, #ff1a1d22, #ff232630, #ffa1a9b1, #fffcfcfc, #ffa1a9b1, #ff141618, #ff202226, #ff0a0b0d, #ff292c3c, #ffa1a9b1, #ffa1a9b1, #ffa1a9b1, #ff1d2026, #fffcfcfc, #ff292c3c, #fffcfcfc, #80a1a9b1, #ff292c3c
    disabled_colors=#ff606873, #ff292c3c, #ff454a52, #ff3a3d47, #ff1a1d22, #ff232630, #ff606873, #fffcfcfc, #ff606873, #ff141618, #ff202226, #ff0a0b0d, #ff202226, #ff606873, #ff7ca0bc, #ffb0a0c0, #ff1d2026, #fffcfcfc, #ff292c3c, #fffcfcfc, #80a1a9b1, #ff202226
  '';

  adwaitaCursorTheme = pkgs.runCommandLocal "adwaita-cursor-default-theme" { } ''
    mkdir -p $out/share/icons
    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita $out/share/icons/default
  '';
in
{
  options.desktop.tilingWmBase = {
    enable = mkEnableOption "Shared tiling WM base configuration";

    screenshot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable screenshot tools for tiling WMs";
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        fuzzel
        pwvucontrol
        swaybg
        swayimg
        waybar
        mako
      ];
      description = "Extra packages to install with the tiling WM base";
    };

    polkit = mkOption {
      type = types.bool;
      default = true;
      description = "Enable mate polkit systemd agent";
    };

    dms = mkOption {
      type = types.bool;
      default = true;
      description = "Enable DankMaterialShell";
    };
  };

  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    systemd.tmpfiles.rules = builtins.concatMap (
      username:
      let
        homeDir = users.${username}.home or "/home/${username}";
      in
      [
        "d ${homeDir}/.config/qt5ct 0755 ${username} users -"
        "d ${homeDir}/.config/qt5ct/colors 0755 ${username} users -"
        "L+ ${homeDir}/.config/qt5ct/colors/breeze-dark.conf - - - - ${breezeDarkQt5ct}"
        "d ${homeDir}/.config/qt6ct 0755 ${username} users -"
        "d ${homeDir}/.config/qt6ct/colors 0755 ${username} users -"
        "L+ ${homeDir}/.config/qt6ct/colors/breeze-dark.conf - - - - ${breezeDarkQt5ct}"
      ]
    ) normalUsers;

    systemd.user.services.mate-policykit-agent-1 = mkIf cfg.polkit {
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

    programs.dank-material-shell = mkIf cfg.dms {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      dgop.package = pkgs.unstable.dgop;

      enableVPN = false;
      enableSystemMonitoring = false;
      enableDynamicTheming = false;
      enableAudioWavelength = false;
      enableCalendarEvents = false;
      enableClipboardPaste = false;
    };

    environment.systemPackages =
      with pkgs;
      [
        adwaitaCursorTheme
        alacritty

        wl-clip-persist
        wl-clipboard
        xclip
      ]
      ++ optionals (cfg.screenshot.enable or false) [
        grim
        slurp
        swappy
        hyprpicker
      ]
      ++ (cfg.extraPackages or [ ]);
  };
}
