{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ../../modules/hyprland.nix
     ../../modules/services.nix
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
    wireless.enable = true;
    networkmanager = { 
        enable = true; 
         unmanaged = [
            "*" "except:type:wwan" "except:type:gsm"
    ];
    };
    firewall = {
      enable = false;
    };
  };

  system.stateVersion = "23.05";
}
