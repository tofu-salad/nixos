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
      steam = mkOption {
        enable = false;
        type = types.bool;
        description = "enable steam";
      };
    };
  };
  config = mkMerge [
    (mkIf config.gaming.enable (mkMerge [
      {
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
