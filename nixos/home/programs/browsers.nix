{ pkgs, config, ... }:
{
  programs = {
    chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "kbmfpngjjgdllneeigpgjifpgocmfgmb" # Reddit Enhancement Suite
        "jinjaccalgkegednnccohejagnlnfdag" # Violentmonkey
      ];
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };
  };
}
