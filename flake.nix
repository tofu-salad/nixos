{
  description = "Zero Calorie Soda NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      persona = "soda";
      sodaNixOs = "desktop";
      standAlone = "manager";
    in
    {
      nixosConfigurations = {
        ${sodaNixOs} = nixpkgs.lib.nixosSystem
          {
            inherit system pkgs;
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ./nixos
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit pkgs;
                };
                home-manager.useUserPackages = true;
                home-manager.useGlobalPkgs = true;
                home-manager.users.${persona} = ./nixos/home;
              }
              {
                nix.settings = {
                  experimental-features = [ "nix-command" "flakes" ];
                };
              }
            ];
          };
      };

      homeConfigurations = {
        ${standAlone} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager
          ];
        };
      };
    };
}
