{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services
    ../../modules/gaming.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings.auto-optimise-store = true;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  boot = {
    kernelParams = [
      "quiet"
      "splash"
    ];
    loader = {
      timeout = 1;
      grub = {
        enable = true;
        efiSupport = true;
        configurationLimit = 3;
        useOSProber = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "laptop";
    networkmanager = {
      enable = true;
    };
  };

  time = {
    hardwareClockInLocalTime = false;
    timeZone = "America/Argentina/Cordoba";
  };

  i18n = {
    defaultLocale = "es_AR.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
      "es_AR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "es_AR.UTF-8";
      LC_IDENTIFICATION = "es_AR.UTF-8";
      LC_MEASUREMENT = "es_AR.UTF-8";
      LC_MONETARY = "es_AR.UTF-8";
      LC_NAME = "es_AR.UTF-8";
      LC_NUMERIC = "es_AR.UTF-8";
      LC_PAPER = "es_AR.UTF-8";
      LC_TELEPHONE = "es_AR.UTF-8";
      LC_TIME = "es_AR.UTF-8";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.tofu = {
    isNormalUser = true;
    description = "tofu salad laptop config";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
    ];
  };

  fhs.enable = true;
  desktopEnvironment = {
    gnome.enable = true;
    loginManager.manager = "gdm";
  };

  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts = {
    fontconfig.subpixel.lcdfilter = "light";
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
      font-awesome
      ibm-plex
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  # programs.zsh.enable = false;
  # environment.pathsToLink = [ "/share/zsh" ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "adw-gtk3";
  };

  programs = {
    dconf = {
      profiles = {
        user = {
          databases = [
            {
              lockAll = true;
              settings = {
                "org/gnome/desktop/interface" = {
                  gtk-theme = "adw-gtk3";
                  font-hinting = "slight";
                  font-antialiasing = "rgba";
                  font-name = "Inter Variable 11";
                };
              };
            }
          ];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    firefox

    stremio
    vlc
    libreoffice-qt

    adwaita-icon-theme
    curl
    gcc
    git
    gsettings-desktop-schemas
    libnotify
    libva-utils
    vim
    neovim
    dbus
    wget
    alacritty

    # dev
    tmux
    gh

    adw-gtk3
    gnome-network-displays
  ];

  system.stateVersion = "24.11";
}
