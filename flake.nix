{
  description = "Zero Calorie Soda NixOS Flake";
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      "https://hyprland.cachix.org"
      # "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys =
      [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };

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
              inherit inputs pkgs-unstable;
            };
            modules = [
              ./nixos
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable;
                };
                home-manager.useUserPackages = true;
                home-manager.useGlobalPkgs = true;
                home-manager.users.${persona} = ./nixos/home;
              }
            ];
          };
      };

      homeConfigurations.${persona} =
        home-manager.lib.homeManagerConfiguration {
          inherit  pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager
          ];
        };
    };
}
