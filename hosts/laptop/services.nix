{
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  services.flatpak.enable = true;
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
