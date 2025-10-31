{
  description = "tofu salad nix flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    emby-flake.url = "github:tofu-salad/emby-server-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      emby-flake,
      ghostty,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./modules
            ./hosts/desktop
          ];
        };

        homelab = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/homelab
            emby-flake.nixosModules.default
          ];
        };
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./modules
            ./hosts/laptop
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./modules
            ./hosts/vm
          ];
        };
      };
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          tools = pkgs.mkShell {
            packages = with pkgs; [
              nixd
              nixfmt-rfc-style
              nixfmt-tree
            ];
          };
          default = outputs.devShells.${system}.tools;
        }
      );

      # homeConfigurations = {
      #   ${hosts.home-manager.name} = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #
      #     extraSpecialArgs = {
      #       inherit inputs;
      #     };
      #
      #     modules = [
      #       ./hosts/home-manager
      #       commonSettings
      #     ];
      #   };
      # };
    };
}
