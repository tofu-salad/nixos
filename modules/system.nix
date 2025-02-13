{ config, pkgs, ... }:

{
  users = {
    users = {
      dezequiel = {
        isNormalUser = true;
        description = "Diego Ezequiel";
        extraGroups = [ "networkmanager" "wheel" "plugdev" ];
        packages = with pkgs; [ ];
        shell = pkgs.zsh;
      };
    };
  };

  time = {
    hardwareClockInLocalTime = true;
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
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    dbus = { enable = true; };
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "dezequiel";
        };
        default_session = initial_session;
      };
    };
    gvfs = { enable = true; };
    tumbler = { enable = true; };
    udev = { packages = [ pkgs.android-udev-rules ]; };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 19000 8081 ];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    sysstat
    lm_sensors
    scrot
    neofetch

    xfce.thunar
  ];
}
