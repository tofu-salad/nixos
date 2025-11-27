# tofusalad nix config

## usage:
```Makefile
Available commands:
  make desktop             - Rebuild system for desktop
  make homelab             - Rebuild system for homelab
  make laptop              - Rebuild system for laptop

  make update/all          - Update all inputs
  make update/emby-flake   - Update emby flake
  make update/home-manager - Update home-manager flake
  make update/stable       - Update nixpkgs
  make update/unstable     - Update nixpkgs-unstable

  make format  	           - Format nix files using nixfmt-rfc-style and nixfmt-tree (can be accessed with nix develop)
```

## To test one of my NixOS configs:
1. Clone the repo.
2. Run `sudo nixos-generate-config --hardware-config hosts/<host>/hardware-configuration.nix`
3. Replace the existing hardware-configuration.nix with your own.
4. Run the desired make command
