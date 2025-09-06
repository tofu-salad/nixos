{
  inputs,
  outputs,
  config,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  fonts = {
    fontDir.enable = true;
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    useGlobalPkgs = true;
    users.tofu = import ../${config.networking.hostName}/home;
  };
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
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
}
