{
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  security.rtkit.enable = true;
  services = {
    avahi.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = false;
      pulse.enable = true;
    };
    resolved.enable = true;
    tailscale.enable = true;
  };
}
