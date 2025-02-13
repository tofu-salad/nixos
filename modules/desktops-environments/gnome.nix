{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-maps
    gnome-connections
    gnome-software
    gnome-music
    gnome-contacts
    gnome-console
    totem
    epiphany
    geary
    snapshot
  ];
}
