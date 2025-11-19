.DEFAULT_GOAL := help

.PHONY: help laptop desktop homelab \
        update/stable update/unstable update/home-manager \
        update/emby-flake update/all \
	format

help:
	@echo "Available commands:"
	@echo "  make desktop             - Rebuild system for desktop"
	@echo "  make homelab             - Rebuild system for homelab"
	@echo "  make laptop              - Rebuild system for laptop"
	@echo
	@echo "  make update/all          - Update all inputs"
	@echo "  make update/emby-flake   - Update emby flake"
	@echo "  make update/home-manager - Update home-manager flake"
	@echo "  make update/stable       - Update nixpkgs"
	@echo "  make update/unstable     - Update nixpkgs-unstable"
	@echo
	@echo "  make format  	           - Format nix files using nixfmt-rfc-style and nixfmt-tree (can be accessed with nix develop)"
format:
	treefmt .
# hosts
laptop:
	sudo nixos-rebuild switch --flake .#laptop

desktop:
	sudo nixos-rebuild switch --flake .#desktop

homelab:
	sudo nixos-rebuild switch --flake .#homelab

# updates
update/stable:
	sudo nix flake update nixpkgs

update/unstable:
	sudo nix flake update nixpkgs-unstable

update/home-manager:
	nix flake update home-manager

update/emby-flake:
	nix flake update emby-flake

update/all:
	sudo nix flake update
