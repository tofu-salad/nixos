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
    networkmanager = { enable = true; };
  };

  system.stateVersion = "23.05";
}
