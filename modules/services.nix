{ config, pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        defaultSession = "sway";
        sddm = {
          enable = true;
        };
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
    gvfs = { enable = true; };
    tumbler = { enable = true; };
    avahi = { enable = true; };
  };
}
