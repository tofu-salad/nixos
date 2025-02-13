{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  services = {
    gvfs = {
      enable = true;
    };
  };

  environment.sessionVariables = {
    POLKIT_AUTH_AGENT = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    dunst
    polkit_gnome

    libsecret
  ];
}
