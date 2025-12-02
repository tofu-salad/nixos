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
        extensions = {
          enable = mkOption {
            default = false;
            type = types.bool;
            description = "enable gnome shell extensions";
          };
          packages = mkOption {
            default = with pkgs.gnomeExtensions; [
              dash-to-dock
              appindicator
            ];
            type = with types; listOf package;
            description = "list of gnome shell extension packages to install. (dash-to-dock and appindicator as default)";
          };
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
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      services.gnome.core-apps.enable = true;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;
      services.gnome.gnome-online-accounts.enable = cfg.gnome.online-accounts;
      services.gnome.gcr-ssh-agent.enable = false;
      programs.ssh.startAgent = true;

      environment.gnome.excludePackages = with pkgs; [
        showtime
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
        (if cfg.gnome.extensions.enable then cfg.gnome.extensions.packages else [ ])
        ++ [
          pkgs.alacritty
          pkgs.wl-clipboard
        ];
      services.udev.packages = [ pkgs.gnome-settings-daemon ];

      programs.dconf.profiles.user.databases = [
        {
          lockAll = true;
          settings = mkMerge [
            {
              "org/gnome/desktop/wm/keybindings" = {
                close = lib.gvariant.mkArray [ "<Super>q" ];

                switch-to-workspace-1 = lib.gvariant.mkArray [ "<Super>1" ];
                switch-to-workspace-2 = lib.gvariant.mkArray [ "<Super>2" ];
                switch-to-workspace-3 = lib.gvariant.mkArray [ "<Super>3" ];
                switch-to-workspace-4 = lib.gvariant.mkArray [ "<Super>4" ];
                switch-to-workspace-5 = lib.gvariant.mkArray [ "<Super>5" ];
                switch-to-workspace-6 = lib.gvariant.mkArray [ "<Super>6" ];
                switch-to-workspace-7 = lib.gvariant.mkArray [ "<Super>7" ];
                switch-to-workspace-8 = lib.gvariant.mkArray [ "<Super>8" ];
                switch-to-workspace-9 = lib.gvariant.mkArray [ "<Super>9" ];

                move-to-workspace-1 = lib.gvariant.mkArray [ "<Super><Shift>1" ];
                move-to-workspace-2 = lib.gvariant.mkArray [ "<Super><Shift>2" ];
                move-to-workspace-3 = lib.gvariant.mkArray [ "<Super><Shift>3" ];
                move-to-workspace-4 = lib.gvariant.mkArray [ "<Super><Shift>4" ];
                move-to-workspace-5 = lib.gvariant.mkArray [ "<Super><Shift>5" ];
                move-to-workspace-6 = lib.gvariant.mkArray [ "<Super><Shift>6" ];
                move-to-workspace-7 = lib.gvariant.mkArray [ "<Super><Shift>7" ];
                move-to-workspace-8 = lib.gvariant.mkArray [ "<Super><Shift>8" ];
                move-to-workspace-9 = lib.gvariant.mkArray [ "<Super><Shift>9" ];
              };

              # unset pinned applications keybind
              "org/gnome/shell/keybindings" = {
                switch-to-application-1 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-2 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-3 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-4 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-5 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-6 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-7 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-8 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
                switch-to-application-9 = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
              };
              "org/gnome/desktop/input-sources".xkb-options = lib.gvariant.mkArray [
                "terminate:ctrl_alt_bksp"
                "caps:escape"
              ];

              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
              };

              "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                ];
              };

              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                binding = "<Super>Return";
                command = "${pkgs.alacritty}/bin/alacritty";
                name = "alacritty";
              };
            }
            (mkIf cfg.gnome.extensions.enable {
              "org/gnome/shell" = {
                enabled-extensions = map (ext: ext.extensionUuid) cfg.gnome.extensions.packages;
              };
            })
          ];
        }
      ];
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
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gnome.localsearch.enable = true;
      programs.niri.enable = true;

      environment.systemPackages =
        with pkgs;
        [
          alacritty
          fuzzel
          pwvucontrol
          swaybg
          swayimg
          wl-clipboard

          waybar
          mako
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
