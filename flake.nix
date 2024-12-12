{
  description = "tofu salad nix flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      hosts = {
        desktop = {
          name = "desktop";
          user = "tofu";
        };
        laptop.name = "laptop";
        home-manager.name = "home-manager";
      };

      commonSettings = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      homeManagerBaseConfig = {
        useUserPackages = true;
        useGlobalPkgs = true;
        users.${hosts.desktop.user} = ./hosts/desktop/home;
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    in
    {
      nixosConfigurations = {
        ${hosts.laptop.name} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./laptop
            commonSettings
          ];
        };
        ${hosts.desktop.name} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/desktop
            home-manager.nixosModules.home-manager
            {
              home-manager = homeManagerBaseConfig;
            }
            commonSettings
          ];
        };
      };

      homeConfigurations = {
        ${hosts.home-manager.name} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          modules = [
            ./home-manager
            commonSettings
          ];
        };
      };
    };
}
