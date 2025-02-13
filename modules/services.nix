
{ config, pkgs, ... }:
{
  hardware.pulseaudio.enable = false;
  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    dbus = { enable = true; };
     greetd = {
       enable = true;
       settings = rec {
         initial_session = {
           command = "Hyprland";
           user = "soda";
         };
         default_session = initial_session;
       };
     };
    gvfs = { enable = true; };
    tumbler = { enable = true; };
    avahi = {enable = true; };
  };
}
