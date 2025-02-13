{ pkgs, config, ... }:
{
  services.flatpak.enable = true;

  # Autologin Workaround
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = false;
      xkb = {
        variant = "";
        layout = "us";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
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
