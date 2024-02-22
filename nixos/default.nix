{ config, pkgs, ... }:

{
  imports = [
    ../modules/system.nix
    ../modules/services.nix
    # ../modules/gaming.nix
    ./hardware-configuration.nix

    # Desktop environments
    ../modules/hyprland.nix
    # ../modules/kde.nix
    ../modules/fhs.nix
    ../modules/virtualization.nix
  ];
  boot = {
    loader = {
      timeout = 2;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi = { canTouchEfiVariables = true; };
    };
  };

  networking = {
    hostName = "desktop";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [ 80 443 8010 1118 ];
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
      ];
    };
  };

  system.stateVersion = "23.11";
}
