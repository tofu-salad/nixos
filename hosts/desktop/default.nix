{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system.nix
    ../../modules/hyprland.nix
    ../../modules/services.nix
    ../../modules/gaming.nix
    ./hardware-configuration.nix
    ../../modules/sway.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      enable = true;
    };
  };

  system.stateVersion = "23.05";
}
