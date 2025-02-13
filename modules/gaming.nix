{ pkgs, config, inputs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
  ];
}
