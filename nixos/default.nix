{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/virtualization.nix
    ../modules/system.nix
    ../modules/fhs.nix
    ../modules/gaming.nix
    ../modules/rnnoise.nix
    ../modules/desktops-environments
    ../modules/services.nix
    ../modules/gc.nix
  ];
  boot = {
    loader = {
      timeout = 2;
      grub = {
        enable = true;
        configurationLimit = 3;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
        8010
        1118
      ];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
