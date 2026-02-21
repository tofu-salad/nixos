{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.tilingWmBase;
  adwaita-cursor-default-theme = pkgs.runCommandLocal "adwaita-cursor-default-theme" { } ''
    mkdir -p $out/share/icons
    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita $out/share/icons/default
  '';
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
        fuzzel
        pwvucontrol
        swaybg
        swayimg
        waybar
        mako
      ];
      description = "extra packages to install with the tiling wm base";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        adwaita-cursor-default-theme
        alacritty
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
