{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.gaming;
in
{
  options.gaming = {
    steam.enable = mkEnableOption "Steam (with adwaita icon themes)";
    lutris.enable = mkEnableOption "Lutris";
    mangohud.enable = mkEnableOption "MangoHud";
    wine.enable = mkEnableOption "Wine (wayland) and Winetricks";
    gamescope.enable = mkEnableOption "Gamescope";
    gamemode.enable = mkEnableOption "GameMode";
  };
  config = mkMerge [
    (mkIf cfg.steam.enable {
      programs.steam = {
        enable = true;
        extraPackages = with pkgs; [
          adwaita-icon-theme
          adwaita-icon-theme-legacy
        ];
      };
    })
    (mkIf cfg.lutris.enable {
      environment.systemPackages = with pkgs; [ lutris ];
    })
    (mkIf cfg.mangohud.enable {
      environment.systemPackages = with pkgs; [ mangohud ];
    })
    (mkIf cfg.wine.enable {
      environment.systemPackages = with pkgs; [
        wineWow64Packages.waylandFull
        winetricks
      ];
    })
    (mkIf cfg.gamescope.enable {
      programs.gamescope.enable = true;
    })
    (mkIf cfg.gamemode.enable {
      programs.gamemode.enable = true;
    })
  ];
  # noga-ng2103-sdl2-gamepad-string:
  # 0300493c1008000001e5000010010000,NOGA-NG2103,platform:Linux,a:b2,b:b1,x:b3,y:b0,back:b8,start:b9,leftshoulder:b4,rightshoulder:b5,leftx:a0,lefty:a1,lefttrigger:b6,righttrigger:b7,
}
