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
    extraConfig.pipewire."99-input-denoising" = {
      "context.modules" = [
        {
          "name" = "libpipewire-module-filter-chain";
          "args" = {
            "node.description" = "Noise Canceling source";
            "media.name" = "Noise Canceling source";
            "filter.graph" = {
              "nodes" = [
                {
                  "type" = "ladspa";
                  "name" = "rnnoise";
                  "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  "label" = "noise_suppressor_mono";
                  "control" = {
                    "VAD Threshold (%)" = 50.0;
                    "VAD Grace Period (ms)" = 200;
                    "Retroactive VAD Grace (ms)" = 0;
                  };
                }
              ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.rate" = 48000;
            };
            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };
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
