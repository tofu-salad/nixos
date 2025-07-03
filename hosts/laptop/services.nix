{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services = {
    avahi = {
      enable = true;
    };
    pipewire = {
      alsa.enable = true;
      enable = true;
      jack.enable = false;
      pulse.enable = true;
    };
    resolved.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
