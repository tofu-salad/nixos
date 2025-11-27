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

  virt = {
    enable = false;
    docker.enable = false;
    virt-manager = {
      enable = true;
      gpuPass = {
        enable = true;
        gpu = "1002:67df,1002:aaf0";
        lookingGlass = {
          enable = true;
          user = "tofu";
        };
      };
    };
  };

  fhs.enable = true;
  screenCastOBS.enable = true;
  desktopEnvironment = {
    sway.enable = true;
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

  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts = {
    fontconfig.subpixel.lcdfilter = "light";
    packages = with pkgs; [
      adwaita-fonts
      font-awesome
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.direnv.enable = true;
  environment.systemPackages = with pkgs; [
    discord
    qbittorrent
    unstable.gimp3

    # browsers
    firefox
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
    stremio
    tidal-hifi

    # nvim+dependencies
    gcc
    lua51Packages.lua
    luajitPackages.luarocks
    tree-sitter
    unstable.neovim
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

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "24.11";
}
