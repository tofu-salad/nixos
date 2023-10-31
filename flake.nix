{
  description = "Zero Calorie Soda NixOS Flake";
  nixConfig = {
experimental-features= [ "nix-command" "flakes" ];
substituters = [
	"https://hyprland.cachix.org"
	"https://cache.nixos.org/"

];
extra-trusted-public-keys = [
"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
];
};
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
let
	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
			config = { allowUnfree = true; };
		};
in{
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs; };
        modules = [
          ./hosts/desktop
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              users = { soda = import ./home; };
            };
          }
        ];
      };
    };
  };
}
