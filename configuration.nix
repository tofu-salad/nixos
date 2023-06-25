# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let 
	dbus-sway-environment = pkgs.writeTextFile {
		name = "dbus-sway-environment";
		destination = "/bin/dbus-sway-environment";
		executable = true;
		text = ''
			dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
			systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
			systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
		'';
	};
	configure-gtk = pkgs.writeTextFile {
		name = "configure-gtk";
		destination = "/bin/configure-gtk";
		executable = true;
		text = let
			schema = pkgs.gsettings-desktop-schemas;
			datadir = "${schema}/share/gsettings-schemas/${schema.name}";
		in ''
		export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
		gnome_schema=org.gnome.desktop.interface
		gsettings set $gnome_schema gtk-theme 'dracula'
		'';
	};
	my-python-packages = ps: with ps; [
		pandas
	];
in

{
	# Include the results of the hardware scan.
	imports = [ ./hardware-configuration.nix ];

	# Bootloader.
	boot.loader = {
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/boot";
		};
		grub = {
			enable = true;
            device = "nodev";
            useOSProber = true;
			efiSupport = true;
		};
	};

	networking.hostName = "nixos"; # Define your hostname.
	networking.networkmanager.enable = true;

	time = {
		hardwareClockInLocalTime = true;
		timeZone = "America/Argentina/Cordoba";
	};
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
			LC_ADDRESS = "es_AR.UTF-8";
			LC_IDENTIFICATION = "es_AR.UTF-8";
			LC_MEASUREMENT = "es_AR.UTF-8";
			LC_MONETARY = "es_AR.UTF-8";
			LC_NAME = "es_AR.UTF-8";
			LC_NUMERIC = "es_AR.UTF-8";
			LC_PAPER = "es_AR.UTF-8";
			LC_TELEPHONE = "es_AR.UTF-8";
			LC_TIME = "es_AR.UTF-8";
	};


	users.users.dezequiel = {
			isNormalUser = true;
			description = "Diego Ezequiel";
			extraGroups = [ "networkmanager" "wheel" ];
			packages = with pkgs; [];
	};

	nixpkgs.config.allowUnfree = true;

	services = {
		xserver = {
			layout = "us";
			xkbVariant = "";
		};
		pipewire = {
			enable = true;
			alsa.enable = true;
			pulse.enable = true;
		};
		dbus = {
			enable = true;
		};
		greetd = {
			enable = true;
			settings = rec {
				initial_session = {
					command ="${pkgs.sway}/bin/sway";
					user = "dezequiel";
				};
				default_session = initial_session;
			};
		};
	};


	xdg.portal = {
		enable = true;
		wlr.enable = true;
		extraPortals = [pkgs.xdg-desktop-portal-gtk];
	};
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
	};
	

	environment.systemPackages = with pkgs; [
		alacritty
		kitty
		configure-gtk
		wayland
		xdg-utils
		dracula-theme
		gnome3.adwaita-icon-theme
		grim
		glib
		slurp
		dunst
		wdisplays
		dunst
		tofi
		neovim
		gnome.nautilus

		# Web Browsers
		chromium
		firefox

		# Media
		mpv
		swayimg

		# Tools
        exa
		git
		ripgrep
		curl
		wget
		unzip
		wl-clipboard
		fd
		tmux
		zsh
		oh-my-zsh

		# Sway
		dbus-sway-environment
		swaylock
		swayidle

		# Programming Languages
		go
		lua
		libgccjit
		gcc
		(python3.withPackages my-python-packages)
		# Javascript
		nodejs_18
			nodePackages.pnpm
			yarn

		# Rust
		rustc
			cargo
			rustfmt
			rust-analyzer
			clippy
	];
	fonts.fonts = with pkgs; [
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		(nerdfonts.override { fonts = ["FiraCode"]; })
	];


	virtualisation.docker.enable = true;
	system.stateVersion = "23.05"; # Did you read the comment?
}
