{
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./services.nix
  ];
  boot = {
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
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
    description = "laptop config";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
      "input"
    ];
  };

  gaming.enable = true;
  desktopEnvironment.gnome.enable = true;
  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts = {
    packages = with pkgs; [
      adwaita-fonts
      # windows fonts
      corefonts
      vistafonts
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GSK_RENDERER = "ngl";
  };

  environment.systemPackages = with pkgs; [
    btop
    curl
    fd
    fzf
    gcc
    gh
    git
    jq
    libnotify
    libva-utils
    p7zip
    ripgrep
    stow
    tmux
    unrar
    unstable.neovim
    unzip
    wget
  ];

  boot.kernelModules = [ "uinput" ];
  system.stateVersion = "24.11";
}
