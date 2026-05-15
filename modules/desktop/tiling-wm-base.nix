{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.desktop.tilingWmBase or { enable = false; };
  adwaitaCursorTheme = pkgs.runCommandLocal "adwaita-cursor-default-theme" { } ''
    		    mkdir -p $out/share/icons
    		    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita $out/share/icons/default
    		  '';
in
{
  options.desktop.tilingWmBase = {
    enable = mkEnableOption "Shared tiling WM base configuration";

    screenshot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable screenshot tools for tiling WMs";
    };
  };

  config = mkIf cfg.enable {

    security.polkit.enable = true; # make sure to check if using gnome or kde to config their polkit agent
    environment.systemPackages =
      with pkgs;
      [
        adwaitaCursorTheme
        fuzzel
        ghostty
        mako
        pwvucontrol
        swayidle
        waybar

        wl-clip-persist
        wl-clipboard
        xclip
      ]
      ++ optionals (cfg.screenshot.enable or false) [
        grim
        hyprpicker
        satty
        slurp
      ];

    # Services
    systemd.user.services.swaybg = {
      enable = true;
      description = "Swaybg wallpaper service";

      unitConfig = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        Requisite = [ "graphical-session.target" ];
      };

      serviceConfig = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i %h/Wallpapers/birmingham-museums-trust-1953P60-Chinese-Scene-With-Figures-Playing.jpg";
        Restart = "on-failure";
      };

      wantedBy = [ "graphical-session.target" ];
    };

    systemd.user.services.wl-clip-persist = {
      enable = true;
      description = "Persist Wayland clipboard";

      unitConfig = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        Requisite = [ "graphical-session.target" ];
      };

      serviceConfig = {
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
        Restart = "on-failure";
      };

      wantedBy = [ "graphical-session.target" ];
    };
  };
}
