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
    "lightdm"
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
  polkitWrapper = pkgs.writeShellScript "polkit-wrapper" ''
    if [ "$XDG_SESSION_DESKTOP" = "sway" ] || [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
      exec ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1
    else
      exit 0
    fi
  '';
in
{
  options = {
    desktopEnvironment = {
      cinnamon = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "cinnamon desktop environment";
        };
      };
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
      services.xserver.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      environment.gnome.excludePackages = with pkgs; [
        decibels
        epiphany
        evince
        geary
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-maps
        gnome-music
        gnome-software
        gnome-tour
        snapshot
        totem
      ];
      environment.systemPackages =
        (with pkgs.gnomeExtensions; [
          dash-to-dock
          appindicator
        ])
        ++ [
          pkgs.papers
          pkgs.wl-clipboard
        ];
    })
    (mkIf (cfg.gnome.enable && cfg.gnome.online-accounts) {
      services.gnome.gnome-online-accounts.enable = true;
    })
    (mkIf cfg.kde.enable {
      services.desktopManager.plasma6.enable = true;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        konsole
        elisa
        khelpcenter
        plasma-browser-integration
        kate
      ];
      environment.systemPackages = with pkgs; [
        gnome-text-editor
      ];
    })
    (mkIf cfg.cinnamon.enable {
      services.xserver.desktopManager.cinnamon.enable = true;
      environment.systemPackages = with pkgs; [
        papirus-icon-theme
        adwaita-icon-theme-legacy
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
          prettyName = "Sway";
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
          ExecStart = "${polkitWrapper}";
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
      (mkIf (cfg.loginManager.manager == "lightdm") {
        services.xserver.enable = true;
        services.xserver.displayManager.lightdm.enable = true;
      })
      (mkIf (cfg.loginManager.manager == "gdm") {
        services.xserver.displayManager.gdm.enable = true;
      })
      (mkIf (cfg.loginManager.manager == "sddm") {
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;
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
