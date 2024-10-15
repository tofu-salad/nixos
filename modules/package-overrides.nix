{
  config,
  pkgs,
  lib,
  ...
}:

{
  nixpkgs.overlays = [
    (self: super: {
      btop = super.btop.override {
        cudaSupport = true; # Enable CUDA support
        rocmSupport = true; # Enable ROCm support
      };
    })
  ];
}
