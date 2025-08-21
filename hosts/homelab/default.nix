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
  services.openssh = {
  	enable = true;
	settings = {
	PasswordAuthentication = false;
	PermitRootLogin = "no";
	KbdInteractiveAuthentication = false;
	};
  };
  services.fail2ban.enable = true;
  services.gvfs.enable = true;
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
    gh
    git
    google-chrome
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web
    mako
    neovim
    pwvucontrol
    waybar
    wl-clipboard
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
      8096 # Jellyfin
    ];

    allowedUDPPorts = [
      137
      138 # Samba NetBIOS Datagram Service
    ];
  };

  users.groups.media = { };
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.tofu = {
    linger = true;
    isNormalUser = true;
    description = "tofu salad homelab config";
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
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
  system.activationScripts.mediaAcl = {
    text = ''
      echo "Setting ACLs on /mnt/share ..."
      ${pkgs.acl}/bin/setfacl -R -m g:media:rwX /mnt/share
      ${pkgs.acl}/bin/setfacl -R -m d:g:media:rwX /mnt/share
    '';
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "tofu"];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.gnome.gnome-keyring.enable = true;

  system.stateVersion = "25.05";
}
