{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./services.nix
  ];

  desktopEnvironment.kde.enable = true;

  users.users.tofu = {
    isNormalUser = true;
    description = "laptop";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  i18n.defaultLocale = lib.mkForce "es_ES.UTF-8";
  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };

  # windows fonts
  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GSK_RENDERER = "gl";
    LIBVA_DRIVER_NAME = "i965";
  };

  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    # browsers
    google-chrome
    brave

    # media
    celluloid
    localsend

    # gui
    libreoffice
    qbittorrent

    # cli
    fd
    fzf
    gh
    jq
    p7zip
    ripgrep
    tmux
    unrar
    unzip
    wget
  ];

  boot = {
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
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

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;

  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
    ];
  };
  hardware.bluetooth.enable = true;

  system.stateVersion = "24.11";
}
