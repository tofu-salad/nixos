{
  inputs,
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # services
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "share" = {
        "path" = "/mnt/share";
        "browseable" = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "tofu";
        "force group" = "media";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    nssmdns4 = true;
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowPing = true;
  services.caddy.enable = true;
  services.tailscale.enable = true;
  services.jellyfin.enable = true;
  environment.systemPackages = with pkgs; [
    audiobookshelf
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web
  ];

  systemd.user.services.audiobookshelf = {
    enable = true;
    description = "audiobookshelf service";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.audiobookshelf}/bin/audiobookshelf";
      Restart = "on-failure";
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # OpenSSH
      80 # HTTP
      443 # HTTPS
      139 # Samba
      445 # Samba
    ];

    allowedUDPPorts = [
      137
      138 # Samba NetBIOS Datagram Service
    ];
  };

  users.users.tofu = {
    linger = true;
    isNormalUser = true;
    description = "tofu salad homelab config";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
  };
  zramSwap.enable = true;
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

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3;
    timeout = 0;
  };
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
  gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  optimise.automatic = true;
  nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  system.stateVersion = "25.05";
}
