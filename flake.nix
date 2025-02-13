{
  description = "tofu salad nix flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
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
<<<<<<< HEAD

      homeManagerDesktopBaseConfig = {
        useUserPackages = true;
        useGlobalPkgs = true;
<<<<<<< HEAD
<<<<<<< HEAD
        users.${vars.persona} = ./hosts/${vars.desktop}/home;
=======
        users.${vars.persona} = ./hosts/desktop/home;
>>>>>>> 118dd0d (changes)
=======
        users.${hosts.desktop.user} = ./hosts/desktop/home;
>>>>>>> d3dbe6c (small refactor)
        extraSpecialArgs = {
          inherit inputs;
        };
      };
=======
>>>>>>> 37dcdbd (changes)
    in
    {
      nixosConfigurations = {
        ${hosts.laptop.name} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./modules
            ./hosts/laptop
            home-manager.nixosModules.home-manager
            {
              home-manager = hosts.laptop.homeConfig;
            }
            commonSettings
          ];
        };
        ${hosts.desktop.name} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit inputs;
          };
          modules = [
<<<<<<< HEAD
<<<<<<< HEAD
            ./hosts/${vars.desktop}
            home-manager.nixosModules.home-manager
            {
              home-manager = homeManagerDesktopBaseConfig // {
                users.${vars.persona} = ./hosts/${vars.desktop};
              };
=======
=======
            ./modules
>>>>>>> 53a6be6 (refactor)
            ./hosts/desktop
            home-manager.nixosModules.home-manager
            {
<<<<<<< HEAD
              home-manager = homeManagerBaseConfig;
>>>>>>> 118dd0d (changes)
=======
              home-manager = hosts.desktop.homeConfig;
>>>>>>> 37dcdbd (changes)
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
            ./hosts/home-manager
            commonSettings
          ];
        };
      };
    };
}
