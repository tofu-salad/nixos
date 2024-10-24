{ pkgs, ... }:
{

  home.packages = with pkgs; [ google-chrome ];
  programs = {
    firefox = {
      enable = false;
    };
    chromium = {
      enable = true;
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
        { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # reddit enhancement suite
        { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # betterttv
      ];
      commandLineArgs = [ "--enable-features=MiddleClickAutoscroll" ];
    };
  };
}
