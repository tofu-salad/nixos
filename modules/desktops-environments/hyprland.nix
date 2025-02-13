{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktopEnvironment.hyprland;
  screenshotPackages = with pkgs; [
    grim
    slurp
    swappy
  ];
  gnomePackages = with pkgs; [
    baobab # gnome disk usage analyzer
    evince # gnome document viewer
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-font-viewer
    gnome-system-monitor
    gnome-text-editor
    hyprpicker
    loupe # gnome image viewer
    nautilus # gnome Files
  ];
in {
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
    };

    environment.sessionVariables = {
      POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    };

    services.gnome.tinysparql.enable = true;
    services.gnome.localsearch.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages =
      (with pkgs; [
        dunst
        pamixer
        pavucontrol
        rofi-wayland
        swaybg
        swayimg
        waybar
        wl-clipboard
      ])
      ++ screenshotPackages
      ++ gnomePackages;
  };
}
