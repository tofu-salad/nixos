{ config, pkgs, lib, ... }:

{
  hardware.opengl = {
    enable = true;
    # Extra GPU packages
    # extraPackages = with pkgs; [
    # intel-media-driver
    # vaapiVdpau
    # vaapiIntel
    # libvdpau-va-gl
    # intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    # ];
  };
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses

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
    geist-font
    (nerdfonts.override { fonts = [ "IBMPlexMono" "GeistMono" ]; })
  ];

  programs.zsh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  fonts.fontconfig.subpixel.lcdfilter = "light";

  environment.systemPackages = with pkgs; [
    gsettings-desktop-schemas
    vim
    wget
    neofetch
    curl
    git
    gcc
    libnotify
    libva-utils
    gnome.adwaita-icon-theme
  ];
}
