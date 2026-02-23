{
  pkgs,
  outputs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./services.nix
  ];

  nixpkgs.overlays = [
    outputs.overlays.stremio-pr
  ];

  desktopEnvironment.mango.enable = true;
  gaming.enable = true;
  screenCastOBS.enable = true;

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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    calibre
    discord
    qbittorrent
    gimp
    stremio-linux

    # browsers
    brave
    google-chrome

    # cli
    btop-rocm
    curl
    fd
    fzf
    gh
    git
    jq
    ripgrep
    starship
    stow
    tmux
    tree
    unzip
    wget
    # libs
    cifs-utils
    openssl
    p7zip

    # media
    ffmpeg
    mpv
    tidal-hifi

    # nvim+dependencies
    gcc
    lua51Packages.lua
    luajitPackages.luarocks
    tree-sitter
    neovim
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

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;
  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "25.11";
}
