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
        description = "enabling gaming (lutris, steam ,etc)";
      };
      steam = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "enable steam";
        };
      };
    };
  };
  config = mkMerge [
    (mkIf config.gaming.enable (mkMerge [
      {
        # noga-ng2103-sdl2-gamepad-string:
        # 0300493c1008000001e5000010010000,NOGA-NG2103,platform:Linux,a:b2,b:b1,x:b3,y:b0,back:b8,start:b9,leftshoulder:b4,rightshoulder:b5,leftx:a0,lefty:a1,lefttrigger:b6,righttrigger:b7,
        environment.systemPackages = with pkgs; [
          lutris
          wineWowPackages.stable
          winetricks
        ];
      }
      (mkIf config.gaming.steam.enable (mkMerge [
        {
          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
          };
        }
      ]))
    ]))
  ];
}
