{ pkgs, ... }:

let
  screenshotPackages = with pkgs; [
    grim
    slurp
    swappy
  ];

  gnomePackages = with pkgs; [
    baobab # Gnome Disk Usage Analyzer
    evince # Gnome Document Viewer
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-font-viewer
    gnome-system-monitor
    gnome-text-editor
    gnome-weather
    hyprpicker
    loupe # Gnome Image Viewer
    nautilus # Gnome Files
  ];
in
{
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
            chooser_cmd = "${pkgs.wofi}/bin/wofi --show dmenu";
          };
        };
      };
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables = {
    POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  environment.systemPackages =
    (with pkgs; [
      dunst
      swaybg
      swayimg
      waybar
      wl-clipboard
      wofi
    ])
    ++ screenshotPackages
    ++ gnomePackages;
}
