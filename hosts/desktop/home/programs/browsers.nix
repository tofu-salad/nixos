{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;
    };
    chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # tampermonkey
        { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # reddit enhancement suite
        { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # betterttv
      ];
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    };
  };

  home.packages = with pkgs; [
    google-chrome
  ];

  xdg.desktopEntries = {
    google-chrome = {
      name = "Google Chrome";
      genericName = "Web Browser";
      comment = "Access the Internet";
      exec = "env LANGUAGE=es_ES google-chrome-stable %U";
      startupNotify = true;
      icon = "google-chrome";
      type = "Application";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "application/pdf"
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/webcal"
        "x-scheme-handler/mailto"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
    };
  };
}
