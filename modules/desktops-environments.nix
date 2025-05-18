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
  screenshotApps = with pkgs; [
    grim
    hyprpicker
    slurp
    swappy
  ];
  # add specific file explorer on desktop environemnt (nautilus, dolphin, nemo-with-extensions)
  gnomeApps = with pkgs; [
    baobab # gnome disk usage analyzer
    papers # gnome document viewer
    loupe # gnome image viewer
    file-roller

    gnome-calculator
    gnome-characters
    gnome-font-viewer
    gnome-text-editor
  ];

in
{
  options = {
    desktopEnvironment = {
      gnome = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "gnome desktop environment";
        };
        online-accounts = mkOption {
          default = false;
          type = types.bool;
          description = "enables online account sync daemon";
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
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "enable login manager";
        };
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
          user = mkOption {
            type = types.str;
            default = "tofu";
            description = "greeter user";
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
    (mkIf cfg.gnome.enable {
      services.xserver = {
        desktopManager.gnome.enable = true;
      };

      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-maps
        gnome-connections
        gnome-software
        gnome-music
        gnome-contacts
        gnome-console
        totem
        epiphany
        geary
        snapshot
      ];
      environment.systemPackages = (
        with pkgs.gnomeExtensions;
        [
          dash-to-dock
          openweather-refined
          appindicator
        ]
      );
    })
    (mkIf (cfg.gnome.enable && cfg.gnome.online-accounts) {
      services.gnome.gnome-online-accounts.enable = true;
    })
    (mkIf cfg.kde.enable {
      services.xserver.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;

      environment.plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        dolphin
        gwenview
        okular
        oxygen
        khelpcenter
        konsole
        plasma-browser-integration
        print-manager
      ];
    })
    (mkIf cfg.hyprland.enable {
      programs.hyprland = {
        withUWSM = true;
        enable = true;
      };

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

      xdg = {
        portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
      };

      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          dunst
          foot
          hyprpaper
          nemo-with-extensions
          pamixer
          pwvucontrol
          rofi-wayland
          swayimg
          waybar
          wl-clipboard
        ]
        ++ gnomeApps
        ++ screenshotApps;
    })
    (mkIf cfg.sway.enable {
      programs.uwsm.enable = true;
      programs.uwsm.waylandCompositors = {
        sway = {
          prettyName = "Sway (with UWSM)";
          comment = "Sway compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/sway";
        };
      };
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };

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

      xdg = {
        portal = {
          enable = true;
          wlr = {
            enable = true;
            settings = {
              screencast = {
                chooser_type = "dmenu";
                chooser_cmd = "${pkgs.rofi-wayland}/bin/rofi -dmenu";
              };
            };
          };
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
      };
      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          dunst
          foot
          nemo-with-extensions
          pamixer
          pwvucontrol
          rofi-wayland
          swaybg
          swayimg
          waybar
          wl-clipboard
        ]
        ++ gnomeApps
        ++ screenshotApps;
    })

    # login managers configurations
    (mkIf cfg.loginManager.enable (mkMerge [
      (mkIf (cfg.loginManager.manager == "gdm") {
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.displayManager.gdm.wayland = true;
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
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember";
                user = cfg.loginManager.greetd.user;
              };
            }
            cfg.loginManager.greetd.extraSettings
          ];
        };
      })
    ]))
  ];
}
