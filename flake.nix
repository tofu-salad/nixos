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

      vars = {
        laptop = "laptop";
        persona = "tofu";
        desktop = "desktop";
        home-manager = "home-manager";
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
        users.${vars.persona} = ./hosts/${vars.desktop}/home;
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    in
    {
      nixosConfigurations = {
        ${vars.laptop} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./laptop
            commonSettings
          ];
        };
        ${vars.desktop} = nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/${vars.desktop}
            home-manager.nixosModules.home-manager
            {
              home-manager = homeManagerDesktopBaseConfig // {
                users.${vars.persona} = ./hosts/${vars.desktop};
              };
            }
            commonSettings
          ];
        };
      };

      homeConfigurations = {
        ${vars.home-manager} = home-manager.lib.homeManagerConfiguration {
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
