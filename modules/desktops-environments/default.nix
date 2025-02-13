{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment;
  loginManagerType = types.enum [
    "gdm"
    "sddm"
    "greetd"
  ];
in
{
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./kde.nix
    ./sway.nix
  ];

  options = {
    desktopEnvironment = {
      gnome = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "gnome desktop environment";
        };
      };
      kde = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "kde desktop environment";
        };
      };
      hyprland = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "hyprland desktop environment";
        };
      };
      sway = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "sway desktop environment";
        };
      };

      loginManager = {
        manager = mkOption {
          type = loginManagerType;
          default = "greetd";
          description = "login manager to use (greetd, sddm, gdm)";
        };
        greetd = {
          enable = mkEnableOption "greetd login manager with tuigreet";
          vt = mkOption {
            type = types.int;
            default = 7;
            description = "virtual terminal for greetd";
          };
          defaultSession = mkOption {
            type = types.str;
            default = "sway";
            description = "default session for greetd to launch";
          };
          extraSettings = mkOption {
            type = types.attrs;
            default = { };
            description = "additional greetd settings";
          };
        };
      };
    };
  };
  config = mkMerge [
    # desktop environments configurations
    (mkIf cfg.gnome.enable
      {
      }
    )
    (mkIf cfg.kde.enable
      {
      }
    )
    (mkIf cfg.hyprland.enable
      {
      }
    )
    (mkIf cfg.sway.enable
      {
      }
    )
    # login managers configurations
    (mkIf (cfg.loginManager.manager == "gdm") {
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.enable = true;
    })
    (mkIf (cfg.loginManager.manager == "sddm") {
      services.xserver.displayManager.sddm.enable = true;
      services.xserver.enable = true;
    })
    (mkIf (cfg.loginManager.manager == "greetd") {
      services.greetd = {
        enable = true;
        vt = cfg.loginManager.greetd.vt;
        settings = mkMerge [
          {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${cfg.loginManager.greetd.defaultSession}";
              user = "greeter";
            };
          }
          cfg.loginManager.greetd.extraSettings
        ];
      };
    })
  ];
}
