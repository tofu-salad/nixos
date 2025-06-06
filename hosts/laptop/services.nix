{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = false;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    resolved.enable = true;
  };
}
