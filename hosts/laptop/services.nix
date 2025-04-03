{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    resolved.enable = true;
  };
}
