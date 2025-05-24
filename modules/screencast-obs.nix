{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    screenCastOBS = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "enable screen casting with audio using obs + vlc + nginx in a rtmp server";
      };
    };
  };
  config = mkMerge [
    (mkIf config.screenCastOBS.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [
          vlc
        ];
        services.nginx = {
          enable = true;
          additionalModules = [ pkgs.nginxModules.rtmp ];
          appendConfig = ''
            rtmp {
              server {
                listen 1935;
                chunk_size 4096;

                application feed {
                  live on;
                  record off;
                }
              }
            }
          '';
        };
        systemd.services.nginx.wantedBy = lib.mkForce [ ];
        programs.obs-studio = {
          enable = true;
        };
      }
    ]))
  ];
}
