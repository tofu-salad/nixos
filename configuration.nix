{ config, pkgs, lib, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-hyprland
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      "	export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS\n	gnome_schema=org.gnome.desktop.interface\n	gsettings set $gnome_schema gtk-theme 'Dracula'\n";
  };
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures = { gtk = true; };
    };
    zsh = { enable = true; };
    thunar = {
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    androidenv.androidPkgs_9_0.platform-tools
    configure-gtk
    dunst
    glib
    gnome3.adwaita-icon-theme
    kitty
    neovim
    tofi
    wdisplays
    wayland
    xdg-utils

    # Screenshot
    grim
    slurp
    swappy

    # Media
    krita

    # Tools
    bat
    exa
    fd
    fzf
    jq
    oh-my-zsh
    openssl
    ripgrep
    tmux
    tmux-sessionizer
    trash-cli
    udev
    unzip
    wl-clipboard
    zsh

    # Sway
    dbus-sway-environment
    i3blocks
    swayidle
    swaylock
    waybar

  ];
  environment.sessionVariables = rec {
    ANDROID_SDK_ROOT =
      "${pkgs.androidenv.androidPkgs_9_0.platform-tools}/libexec/android-sdk";
    ANDROID_HOME =
      "${pkgs.androidenv.androidPkgs_9_0.platform-tools}/libexec/android-sdk";
  };

  virtualisation = { docker = { enable = true; }; };
}

