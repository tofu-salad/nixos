{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  # environment.systemPackages = with pkgs; [
  #   wineWowPackages.staging
  #   # inputs.nix-gaming.packages.${pkgs.system}.wine-ge
  #   winetricks
  #   lutris
  # ];
}
