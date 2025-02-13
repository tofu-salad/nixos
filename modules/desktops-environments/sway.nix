{ pkgs, ... }:

{
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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpicker
    dunst
    grim
    slurp
    wl-clipboard
  ];
}
