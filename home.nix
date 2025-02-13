{ config, pkgs, ... }:
let
	my-python-packages = ps: with ps; [
		pandas
	];
in
{
  home.username = "dezequiel";
  home.homeDirectory = "/home/dezequiel";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
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
	neovim

	# Programming Languages
	go
	lua
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

  programs.git = {
	enable = true;
	userName = "zeroCalSoda";
	userEmail = "diego.ezequiel.scardulla@gmail.com";
	extraConfig = {
		color = { 
			ui = "auto";
		};
		init = {
			defaultBranch = "main";
		};
		pull = {
			rebase = false;
		};
	};
  };
  home.file = {
  };
  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
