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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    dunst
    grim
    slurp
    wl-clipboard
  ];
}
