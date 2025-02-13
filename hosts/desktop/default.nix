{ config, pkgs, ... }:

{
  imports = [ ../../modules/system.nix ./hardware-configuration.nix ];

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
