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

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };
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
  # apps
  services = {
    audiobookshelf = {
      enable = true;
      openFirewall = true;
      port = 13378;
      host = "0.0.0.0";
    };
    emby.enable = true;
  };

  services.gvfs.enable = true;
  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # OpenSSH
      80 # HTTP
      443 # HTTPS
      8096 # Emby
    ];
    allowedUDPPorts = [ ];
  };

  users.groups.media = { };
  users.users.emby.extraGroups = [ "media" ];
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

  zramSwap.enable = true;
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
      trusted-users = [
        "root"
        "tofu"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  services.dbus.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    gh
    git
    google-chrome
    mako
    neovim
    pwvucontrol
    tmux
    typer
    waybar
    wl-clipboard
  ];

  system.stateVersion = "25.05";
}
