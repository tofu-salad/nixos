{ pkgs, ... }:
{

  home.packages = with pkgs; [
    google-chrome
    # brave 
  ];
  programs = {
    firefox = {
      enable = true;
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
      commandLineArgs = [
        "--enable-features=MiddleClickAutoscroll"
      ];
      package = with pkgs; (chromium.override { enableWideVine = true; });
    };
  };
}
