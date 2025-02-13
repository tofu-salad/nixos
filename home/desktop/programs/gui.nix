{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    nwg-look
    gnome-text-editor
    swayimg
    swappy
  ];
}
