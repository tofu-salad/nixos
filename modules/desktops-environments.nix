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
  gnomeApps = with pkgs; [
    baobab # gnome disk usage analyzer
    evince # gnome document viewer
    loupe # gnome image viewer
    nautilus # gnome Files
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
        enable = true;
      };

      xdg = {
        portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
      };

      environment.sessionVariables = {
        POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      };

      services.gnome.tinysparql.enable = true;
      services.gnome.localsearch.enable = true;
      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          dunst
          pamixer
          pavucontrol
          rofi-wayland
          swaybg
          swayimg
          waybar
          wl-clipboard
        ]
        ++ gnomeApps
        ++ screenshotApps;
    })
    (mkIf cfg.sway.enable {
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
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
      services.gnome.tinysparql.enable = true;
      services.gnome.localsearch.enable = true;
      services.gnome.gnome-keyring.enable = true;
      environment.sessionVariables = {
        POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      };

      environment.systemPackages =
        with pkgs;
        [
          dunst
          pamixer
          pavucontrol
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
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${cfg.loginManager.greetd.defaultSession}";
                user = "greeter";
              };
            }
            cfg.loginManager.greetd.extraSettings
          ];
        };
      })
    ]))
  ];
}
