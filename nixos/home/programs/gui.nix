{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      gnome-text-editor
      gnome-calculator
      gnome-font-viewer

      swayimg
      swappy
      qbittorrent
    ]
  );
}
