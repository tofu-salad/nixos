{ pkgs, config, inputs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    # inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    winetricks
    lutris
  ];
}
