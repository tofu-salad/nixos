{ config, pkgs, ... }:

{
  users = {
    users = {
      soda = {
        isNormalUser = true;
        description = "soda's nixos config";
        extraGroups = [ "networkmanager" "wheel" "plugdev" ];
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
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };

services.flatpak.enable = true;
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
          command = "Hyprland";
          user = "soda";
        };
        default_session = initial_session;
      };
    };
    gvfs = { enable = true; };
    tumbler = { enable = true; };
    # udev = { packages = [ pkgs.android-udev-rules ]; };
  };

  environment.systemPackages = with pkgs; [
  gnome-network-displays
    vim
    wget
    curl
    cinnamon.nemo
    networkmanager-l2tp
    networkmanager-openconnect
    networkmanager-sstp
    git
    sysstat
    lm_sensors
    networkmanager-vpnc
    networkmanagerapplet
    iw
    scrot
  ];
}
