{ pkgs, ... }:
{
  imports = [
    ./languages
  ];

  programs.git = {
    enable = true;
    userName = "tofu-salad";
    userEmail = "67925799+tofu-salad@users.noreply.github.com";
    extraConfig = {
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
    ];
  };

  home.packages = with pkgs; [
    firefox
    btop-rocm
    discord
    fd
    ffmpeg
    fzf
    gh
    google-chrome
    jq
    openssl
    qbittorrent
    ripgrep
    stremio
    tidal-hifi
    tmux
    tree
    unstable.gimp3

    # nvim+dependencies
    lua51Packages.lua
    luajitPackages.luarocks
    tree-sitter
    unstable.neovim
  ];

  home = {
    username = "tofu";
    pointerCursor = {
      gtk.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  gtk = {
    enable = true;
    font.name = "Adwaita Sans";
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "alacritty";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  fonts.fontconfig.enable = true;
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
