{ pkgs, ... }:
{
  services.flatpak.enable = false;
  services = {
    tailscale.enable = true;
    fstrim.enable = true;
    xserver = {
      updateDbusEnvironment = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    dbus = {
      enable = true;
    };

    # automount/unmount drives
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    avahi = {
      enable = true;
    };
  };

  # audio {{{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };
  #}}}

  # firewall {{{
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      80
      443
      8010
      1935
      1118
    ];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };
  #}}}
}

# vim:fileencoding=utf-8:foldmethod=marker
