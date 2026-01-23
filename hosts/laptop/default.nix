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

  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };

  users.users.tofu = {
    isNormalUser = true;
    description = "laptop";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
      "input"
    ];
  };
  i18n.defaultLocale = lib.mkForce "es_ES.UTF-8";
  desktopEnvironment.kde.enable = true;

  # windows fonts
  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
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
    # install stremio as a flatpak for now
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
    wget

    p7zip
    unrar
    unzip

    # neovim
    gcc
    lua51Packages.lua
    luajitPackages.luarocks
    tree-sitter
    neovim
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

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;
  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth.enable = true;

  boot.kernelModules = [ "uinput" ];
  system.stateVersion = "24.11";
}
