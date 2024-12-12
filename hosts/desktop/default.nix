{ config, pkgs, ... }:

{
  imports = [
    # ../modules/gaming.nix
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/fhs.nix
    ../../modules/desktops-environments
    ../../modules/services
  ];
  users = {
    users = {
      tofu = {
        isNormalUser = true;
        description = "tofu salad nixos config";
        extraGroups = [
          "networkmanager"
          "wheel"
          "plugdev"
        ];
      };
    };
  };
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
  };

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
        useOSProber = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "24.11";
}
