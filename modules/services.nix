{ pkgs, config, ... }:
{
  services.flatpak.enable = true;

  # Autologin Workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  services.displayManager.sddm.wayland.enable = true;
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      # extraConfig.pipewire."99-input-denoising" = {
      #   "context.modules" = [
      #     {
      #       name = "libpipewire-module-filter-chain";
      #       args = {
      #         "node.description" = "Noise Canceling source";
      #         "media.name" = "Noise Canceling source";
      #         "filter.graph" = {
      #           nodes = [
      #             {
      #               type = "ladspa";
      #               name = "rnnoise";
      #               plugin = "/home/tofu/.config/pipwireBACKUP/pipewire.conf.d/librnnoise_mono.so";
      #               label = "noise_suppressor_mono";
      #               control = {
      #                 "VAD Threshold (%)" = "50.0";
      #                 "VAD Grace Period (ms)" = "200";
      #                 "Retroactive VAD Grace (ms)" = "0";
      #               };
      #             }
      #           ];
      #         };
      #         "capture.props" = {
      #           "node.name" = "capture.rnnoise_source";
      #           "node.passive" = "true";
      #           "audio.rate" = "48000";
      #         };
      #         "playback.props" = {
      #           "node.name" = "rnnoise_source";
      #           "media.class" = "Audio/Source";
      #           "audio.rate" = "48000";
      #         };
      #       };
      #     }
      #   ];
      # };
    };
    # greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       command = "${pkgs.hyprland}/bin/Hyprland";
    #       user = "tofu";
    #     };
    #     default_session = initial_session;
    #   };
    # };
    dbus = {
      enable = true;
      packages = with pkgs; [ gnome-keyring ];
    };
    avahi = {
      enable = true;
    };
  };
}
