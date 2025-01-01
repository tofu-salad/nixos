{
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      80
      443
      8010
      1118
    ];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };
}
