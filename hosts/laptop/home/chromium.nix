{ pkgs, ... }:
{
  programs.chromium = {
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

  xdg.desktopEntries = {
    chromium-browser = {
      name = "Chromium";
      genericName = "Web Browser";
      comment = "Access the Internet";
      exec = "env LANGUAGE=en_US chromium %U";
      startupNotify = true;
      icon = "chromium";
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
