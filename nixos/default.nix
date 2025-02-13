{ config, pkgs, ... }:

{
  imports = [
    # ../modules/gaming.nix
    ./hardware-configuration.nix
    ../modules/system.nix
    ../modules/fhs.nix
    ../modules/desktops-environments
    ../modules/services
  ];
  boot = {
    # idk if this fixes my shutdown issue
    kernelParams = [
      "acpi=force"
    ];
    loader = {
      timeout = 2;
      grub = {
        enable = true;
        efiSupport = true;
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
  };

  system.stateVersion = "24.11";
}
