{ lib, ... }:
with lib;
{
  options.desktopEnvironment = {
    kde.enable = mkEnableOption "KDE desktop";
    hyprland.enable = mkEnableOption "Hyprland";
    sway.enable = mkEnableOption "Sway";
    niri.enable = mkEnableOption "Niri";
    cosmic.enable = mkEnableOption "Cosmic";
    mango.enable = mkEnableOption "mangowc";
    gnome = {
      enable = mkEnableOption "Gnome Desktop";
      online-accounts = mkOption {
        type = types.bool;
        default = false;
        description = "enable gnome online account sync daemon";
      };
      extensions = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable GNOME Shell extensions";
        };
        packages = mkOption {
          type = with types; listOf package;
          default = with pkgs.gnomeExtensions; [
            dash-to-dock
            appindicator
          ];
          description = "list of gnome shell extensions to install";
        };
      };
    };
  };
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./kde.nix
    ./niri.nix
    ./standalone-gnome-suite.nix
    ./sway.nix
    ./tiling-wm-base.nix
    ./cosmic.nix
    ./standalone-kde-suite.nix
    ./mango.nix
  ];
}
