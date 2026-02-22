{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.desktopEnvironment.qtStyle;

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
in

{
  options.desktopEnvironment.qtStyle = {
    enable = mkEnableOption "Enable Qt style configuration (qt5ct/qt6ct)";
  };

  config = mkIf cfg.enable {


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
  };
}
