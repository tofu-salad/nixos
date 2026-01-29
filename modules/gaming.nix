{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options = {
    gaming = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "enables lutris";
      };
    };
  };
  config = mkMerge [
    (mkIf config.gaming.enable (mkMerge [
      {
        programs.steam = {
          enable = true;
          extraPackages = with pkgs; [
            adwaita-icon-theme
            adwaita-icon-theme-legacy
          ];
        };
        # noga-ng2103-sdl2-gamepad-string:
        # 0300493c1008000001e5000010010000,NOGA-NG2103,platform:Linux,a:b2,b:b1,x:b3,y:b0,back:b8,start:b9,leftshoulder:b4,rightshoulder:b5,leftx:a0,lefty:a1,lefttrigger:b6,righttrigger:b7,
        environment.systemPackages = with pkgs; [
          lutris
          mangohud
        ];
        programs.gamescope.enable = true;
        programs.gamemode.enable = true;
      }
    ]))
  ];
}
