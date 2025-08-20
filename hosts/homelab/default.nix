{ inputs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
  gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  optimise.automatic = true;
  nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
