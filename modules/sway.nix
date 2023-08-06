{ pkgs, ... }:
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
    thunar = {
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };

  # Packages are in system.nix
  environment.systemPackages = with pkgs; [
    configure-gtk
    dunst
    gnome3.adwaita-icon-theme
    tofi
    wdisplays
    wayland

    grim
    slurp
    swappy
    wl-clipboard

    dbus-sway-environment
    i3blocks
    swayidle
    swaylock
    waybar
  ];
}
