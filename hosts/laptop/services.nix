{ pkgs, ... }:

{
  security.rtkit.enable = true;

  services = {
    logind.lidSwitch = "ignore";
    logind.lidSwitchExternalPower = "ignore";
    logind.lidSwitchDocked = "ignore";
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
    # tailscale = {
    #   enable = true;
    #   useRoutingFeatures = "client";
    # };
  };
}
