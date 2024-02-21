{
  description = "Zero Calorie Soda NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      # pkgs-unstable = import nixpkgs-unstable {
      #   inherit system;
      #   config = { allowUnfree = true; };
      # };

      persona = "soda";
      sodaNixOs = "desktop";
      sodaNonNixOs = "manager";
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
                  substituters = [
                    "https://cache.nixos.org/"
                    "https://hyprland.cachix.org"
                  ];
                  trusted-public-keys = [
                    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                  ];
                };
              }
            ];
          };
      };

      homeConfigurations.${persona} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager
          ];
        };
    };
}
