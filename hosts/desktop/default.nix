{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ../../modules/hyprland.nix
#    ../../modules/sway.nix
#    ../../modules/virtualization.nix
#    ../../modules/android.nix
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi = { canTouchEfiVariables = true; };
    };
  };

  networking = {
    hostName = "desktop";
    wireless.enable = false;
    networkmanager = { 
        enable = true; 
        plugins = with pkgs; [ networkmanager-openvpn networkmanager-openconnect ];
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [ 80 443 19000 8081 ];
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

  system.stateVersion = "23.05";
}
