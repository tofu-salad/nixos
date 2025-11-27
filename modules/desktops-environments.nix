{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment;
  screenshotApps = with pkgs; [
    grim
    hyprpicker
    slurp
    swappy
  ];
  gnomeApps = with pkgs; [
    nautilus # file explorer
    baobab # gnome disk usage analyzer
    file-roller
    loupe # gnome image viewer
    papers # gnome document viewer

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
      niri = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "niri desktop environment";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.gnome.enable {
      services.xserver.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      services.gnome.core-apps.enable = true;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;

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
        gnome-user-docs
        snapshot
        totem
      ];

      environment.systemPackages =
        (with pkgs.gnomeExtensions; [
          dash-to-dock
          appindicator
        ])
        ++ [
          pkgs.gnome-tweaks
          pkgs.papers
          pkgs.wl-clipboard
        ];
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
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
        wl-clipboard
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
    (mkIf cfg.niri.enable {
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      programs.waybar.enable = true;
      services.gnome.localsearch.enable = true;

      programs.niri.enable = true;
      environment.systemPackages =
        with pkgs;
        [
          alacritty
          fuzzel
          mako
          pwvucontrol
          swaybg
          swayimg
          wl-clipboard
        ]
        ++ gnomeApps
        ++ screenshotApps;
    })
    (mkIf cfg.sway.enable {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
            user = "greeter";
          };
        };
      };
      security.pam.services.greetd.enableGnomeKeyring = true;
      services.gnome.gnome-keyring.enable = true;

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
        extraPackages = [ ];
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
                chooser_cmd = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.fuzzel}/bin/fuzzel --dmenu --no-exit-on-keyboard-focus-loss";
              };
            };
          };
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
        };
      };
      services.gnome.localsearch.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          waybar
          alacritty
          fuzzel
          mako
          pwvucontrol
          swaybg
          swayimg
          wl-clipboard
        ]
        ++ gnomeApps
        ++ screenshotApps;
    })
  ];
}
