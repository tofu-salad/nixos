{ pkgs, config, ... }:
{
  services.flatpak.enable = true;

  # Autologin Workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
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
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "tofu";
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
