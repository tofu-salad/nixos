{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;
    };
    chromium = {
      enable = true;
      package = (pkgs.chromium.override { enableWideVine = true; });
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
        { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # reddit enhancement suite
        { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # betterttv
      ];
      commandLineArgs = [
        "--enable-features=MiddleClickAutoscroll"
      ];
    };
  };
}
