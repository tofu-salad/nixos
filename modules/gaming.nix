{ pkgs, config, inputs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.staging
    winetricks
  ];
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
}
