{ pkgs, config, ... }:
{
  programs = {
    chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "kbmfpngjjgdllneeigpgjifpgocmfgmb" # Reddit Enhancmenet Suite
      ];
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };

  };
  home.packages = [
    brave
    google-chrome
  ];
}
