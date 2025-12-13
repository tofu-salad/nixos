{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./services.nix
  ];

  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
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
  i18n.defaultLocale = lib.mkForce "es_ES.UTF-8";

  gaming.enable = true;
  desktopEnvironment.gnome.enable = true;
  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # windows fonts
  fonts.packages = with pkgs; [
    corefonts
    vistafonts
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GSK_RENDERER = "ngl";
  };

  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    # browsers
    chromium
    google-chrome

    # media
    stremio
    vlc

    # gui
    libreoffice
    qbittorrent

    # cli
    btop
    curl
    fd
    fzf
    gh
    git
    jq
    ripgrep
    stow
    tmux
    unstable.neovim
    wget

    gcc
    p7zip
    unrar
    unzip
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

  boot.kernelModules = [ "uinput" ];
  system.stateVersion = "24.11";
}
