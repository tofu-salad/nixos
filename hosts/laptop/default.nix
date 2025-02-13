{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings.auto-optimise-store = true;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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

  gaming.enable = true;
  fhs.enable = true;
  desktopEnvironment = {
    gnome.enable = true;
    loginManager = {
      enable = true;
      manager = "gdm";
    };
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
      (nerdfonts.override {
        fonts = [
          "IBMPlexMono"
          "IosevkaTerm"
        ];
      })
      font-awesome
      iosevka
      ibm-plex
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    alacritty
    btop
    curl
    dbus
    eza
    fd
    firefox
    gcc
    gh
    git
    gnome-network-displays
    google-chrome
    gsettings-desktop-schemas
    jq
    libnotify
    libreoffice-qt
    libva-utils
    neovim
    ripgrep
    stremio
    tmux
    unzip
    vim
    vlc
    wget
    wl-clipboard
  ];

  system.stateVersion = "24.11";
}
