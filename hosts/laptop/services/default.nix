{
  imports = [
    ./audio.nix
  ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  services.resolved.enable = true;
}
