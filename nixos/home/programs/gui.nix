{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      gnome-text-editor
      swayimg
      swappy
      font-manager
      qbittorrent
      discord
    ]
  );
}
