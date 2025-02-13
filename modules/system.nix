{ config, pkgs, lib, ... }:

{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
    services.jellyfin.enable = true;

  users = {
    users = {
      soda = {
        shell = pkgs.zsh;
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
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
  ];

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    gsettings-desktop-schemas
    vim
    wget
    neofetch
    curl
    git
    gcc
    gnome.adwaita-icon-theme
  ];
}
