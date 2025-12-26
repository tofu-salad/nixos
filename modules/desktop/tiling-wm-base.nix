{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.tilingWmBase;
in
{
  options.desktop.tilingWmBase = {
    enable = mkEnableOption "shared tiling wm base configuration";

    screenshot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable screenshot tools for tiling wms";
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        mako
        waybar
      ];
      description = "extra packages to install with the tiling wm base";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        alacritty
        fuzzel
        pwvucontrol
        swaybg
        swayimg
        wlogout
        wl-clipboard
      ]
      ++ optionals cfg.screenshot.enable [
        grim
        slurp
        swappy
        hyprpicker
      ]
      ++ cfg.extraPackages;
  };
}
