{ config, pkgs, ... }:
{
  # Autologin Workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services = {
    xserver = {
      displayManager = {
        autoLogin = {
          enable = true;
          user = "soda";
        };
        defaultSession = "hyprland";
      };
      layout = "us";
      xkbVariant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    # greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       command = "Hyprland";
    #       user = "soda";
    #     };
    #     default_session = initial_session;
    #   };
    # };
    dbus = { enable = true; };
    avahi = { enable = true; };
  };
}
