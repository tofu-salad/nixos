{ pkgs, config, ... }:
with pkgs; let
  patchDesktop = pkg: appName: from: to: (lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
    ${coreutils}/bin/mkdir -p $out/share/applications
    ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop ''));
in
{
  programs = {
    chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "kbmfpngjjgdllneeigpgjifpgocmfgmb" # Reddit Enhancmenet Suite
        "fadndhdgpmmaapbmfcknlfgcflmmmieb" # FrankerFaceZ
      ];
      commandLineArgs = [ "--password-store=kwallet5" ];
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };

  };
  home.packages = [
    google-chrome
    (patchDesktop google-chrome "google-chrome" "^Exec=${google-chrome}/bin/google-chrome-stable %U" "Exec=env LANGUAGE=es_ES ${google-chrome}/bin/google-chrome-stable %U --password-store=kwallet5")
  ];
}
