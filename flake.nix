{
  description = "tofu salad nix flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
          homeConfig = {
            useUserPackages = true;
            useGlobalPkgs = true;
            users.tofu = ./hosts/desktop/home;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        };

        laptop = {
          name = "laptop";
          user = "tofu";
          homeConfig = {
            backupFileExtension = "backup";
            useUserPackages = true;
            useGlobalPkgs = true;
            users.tofu = ./hosts/laptop/home;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        };
        home-manager.name = "home-manager";
      };

      commonSettings = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      mkNixosSystem =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./modules
            ./hosts/${host.name}
            home-manager.nixosModules.home-manager
            { home-manager = host.homeConfig; }
            commonSettings
          ];
        };
    in
    {
      nixosConfigurations = {
        ${hosts.desktop.name} = mkNixosSystem hosts.desktop;
        ${hosts.laptop.name} = mkNixosSystem hosts.laptop;
      };

      homeConfigurations = {
        ${hosts.home-manager.name} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/home-manager
            commonSettings
          ];
        };
      };
    };
}
