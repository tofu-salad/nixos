{ pkgs, ... }:
{
  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
        ];
      };
    };
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
      (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
      font-awesome
      ibm-plex
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  # programs.zsh.enable = false;
  # environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    curl
    gcc
    git
    gsettings-desktop-schemas
    libnotify
    libva-utils
    vim
    wget
  ];
}
