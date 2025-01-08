{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
    winetricks
  ];
  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
