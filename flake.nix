{
  description = "tofu's salad nix flake";

  inputs = {

    nixpkgs-70eb14712.url = "github:nixos/nixpkgs/70eb147124031c25a080e7a9f6a770eeb926c813"; # adw-gtk3 fix because my GTK is older than 4.16
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixpkgs-70eb14712,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-70eb14712 = import nixpkgs-70eb14712 {
        inherit system;
        config.allowUnfree = true;
      };
      persona = "tofu";
      tofuNixOS = "nixos";
      standAlone = "manager";
    in
    {
      nixosConfigurations = {
        ${tofuNixOS} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nixos
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit pkgs pkgs-70eb14712;
              };
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.${persona} = ./nixos/home;
            }
            {
              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };
            }
          ];
        };
      };
      homeConfigurations = {
        ${standAlone} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./home-manager ];
        };
      };
    };
}
