{ pkgs, pkgs-unstable, ... }:

{
  home.packages = (with pkgs; [
    gnome-text-editor
    swayimg
    swappy
    font-manager
  ]) ++ (with pkgs-unstable; [ nwg-look ]);
}
