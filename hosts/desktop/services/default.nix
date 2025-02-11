{ pkgs, ... }:
{
  imports = [
    ./gc.nix
    ./audio.nix
    ./firewall.nix
    ./virtualization.nix
  ];

  services.flatpak.enable = false;
  services = {
    fstrim.enable = true;
    xserver = {
      updateDbusEnvironment = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    # automount/unmount drives
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    upower.enable = true;
    dbus = {
      enable = true;
    };

    avahi = {
      enable = true;
    };
  };
}
