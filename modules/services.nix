{ pkgs, config, ... }:
{
  services.flatpak.enable = true;

  # Autologin Workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  services = {
    xserver = {
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
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "tofu";
        };
        default_session = initial_session;
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
