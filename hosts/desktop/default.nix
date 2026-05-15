{
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./services.nix
  ];

  desktopEnvironment.sway.enable = true;
  screenCastOBS.enable = true;

  users.users.tofu = {
    isNormalUser = true;
    description = "tofu salad nixos config";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "iHD";
  };

  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    gimp
    localsend
    celluloid
    qbittorrent

    # browsers
    google-chrome

    # cli
    fd
    fzf
    gh
    jq
    ripgrep
    tmux
    tree
    unzip
    wget
    cargo

    # libs
    cifs-utils
    openssl
    p7zip
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

  fileSystems."/mnt/1tb-hdd" = {
    device = "/dev/disk/by-uuid/5A89-762E";
    fsType = "exfat";
    options = [
      "uid=1000"
      "gid=100"
      "umask=022"
      "users"
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;
  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Accelerated Video Playback
    ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3;
    timeout = 1;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.11";
}
