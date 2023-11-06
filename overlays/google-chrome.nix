{ pkgs, config, lib, ... }:

(final: prev: {
  google-chrome = prev.google-chrome.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      substituteInPlace $out/share/applications/google-chrome.desktop \
        --replace "Exec=" "Exec=LANGAUGE=es_ES"
    '';
  });
})
