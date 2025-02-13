{
  description = "tofu salad nix flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
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
      ghostty,
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
            inherit inputs ghostty;
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
              home-manager = homeManagerBaseConfig;
>>>>>>> 118dd0d (changes)
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
