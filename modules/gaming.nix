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
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
}
