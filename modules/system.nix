{ pkgs, ... }:
{

  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [
    #   intel-media-sdk
    #   intel-media-driver
    #   libvdpau-va-gl
    # ];
  };
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  users = {
    users = {
      tofu = {
        isNormalUser = true;
        description = "tofu's salad nixos config";
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
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    (nerdfonts.override {
      fonts = [
        "IBMPlexMono"
        "GeistMono"
      ];
    })
  ];

  programs.zsh.enable = false;

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
    adwaita-icon-theme
  ];
}
