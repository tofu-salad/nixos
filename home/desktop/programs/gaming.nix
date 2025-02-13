{ pkgs, config, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  home.packages = with pkgs; [
    lutris
  ];
}
