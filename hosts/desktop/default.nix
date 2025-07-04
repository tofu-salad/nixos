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

  virt = {
    enable = false;
    docker.enable = false;
    virt-manager = {
      enable = true;
      gpuPass = {
        enable = true;
        gpu = "1002:67df,1002:aaf0";
        lookingGlass = {
          enable = true;
          user = "tofu";
        };
      };
    };
  };

  # bootloeader
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      timeout = 0;
      grub = {
        enable = false;
        efiSupport = true;
        configurationLimit = 3;
        useOSProber = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  fhs.enable = true;
  screenCastOBS.enable = true;
  desktopEnvironment = {
    # loginManager = {
    #   enable = true;
    #   manager = "gdm";
    # };
    # gnome.enable = true;
    sway.enable = true;
  };

  users = {
    users = {
      tofu = {
        isNormalUser = true;
        description = "tofu salad nixos config";
        extraGroups = [
          "networkmanager"
          "wheel"
          "plugdev"
          "libvirtd"
        ];
      };
    };
  };

  networking = {
    hostName = "desktop";
    networkmanager = {
      enable = true;
    };
  };

  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  time = {
    hardwareClockInLocalTime = false;
    timeZone = "America/Argentina/Cordoba";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
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

  fonts = {
    fontconfig.subpixel.lcdfilter = "light";
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.iosevka-term
      adwaita-fonts
      font-awesome
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    curl
    gcc
    git
    p7zip
    stow
    unzip
    vim
    wget
    cifs-utils
  ];

  fileSystems."/mnt/share" = {
    device = "//192.168.0.12/share";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";

      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };

  system.stateVersion = "24.11";
}
