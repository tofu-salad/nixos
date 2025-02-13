{ pkgs, ... }:

{
  imports = [
    ./gc.nix
    ./audio.nix
    ./firewall.nix
    ./virtualization.nix
  ];

  services.flatpak.enable = true;

  services = {
    xserver = {
      enable = false;
      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = false;
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    greetd = {
      enable = true;
      vt = 7;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
          user = "greeter";
        };
      };
    };

    dbus = {
      enable = true;
      packages = with pkgs; [ gnome-keyring ];
    };

    avahi = {
      enable = true;
    };
  };
}
