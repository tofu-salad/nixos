{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktopEnvironment.sway;
  screenshotPackages = with pkgs; [
    grim
    slurp
    swappy
  ];

  gnomePackages = with pkgs; [
    baobab # gnome disk usage analyzer
    evince # gnome document viewer
    gnome-calculator
    gnome-characters
    gnome-font-viewer
    gnome-text-editor
    hyprpicker
    loupe # gnome image viewer
    nautilus # gnome Files
  ];
in
{
  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    xdg = {
      portal = {
        enable = true;
        wlr = {
          enable = true;
          settings = {
            screencast = {
              chooser_type = "dmenu";
              chooser_cmd = "${pkgs.rofi-wayland}/bin/rofi -dmenu";
            };
          };
        };
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
    services.gnome.tinysparql.enable = true;
    services.gnome.localsearch.enable = true;
    services.gnome.gnome-keyring.enable = true;
    environment.sessionVariables = {
      POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    environment.systemPackages =
      (with pkgs; [
        dunst
        pamixer
        pavucontrol
        swaybg
        swayimg
        waybar
        wl-clipboard
        rofi-wayland
      ])
      ++ screenshotPackages
      ++ gnomePackages;
  };
}
