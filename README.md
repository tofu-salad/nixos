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
## to test one of my NixOS configs:
1. clone the repo.
2. replace the `hardware-configration.nix` inside `hosts/<host>/hardware-configuration.nix` with your own.
5. run the desired make command
