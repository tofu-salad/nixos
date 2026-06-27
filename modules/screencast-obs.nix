{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.screenCastOBS.enable = mkEnableOption "screencasting with OBS + nginx RTMP";
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
