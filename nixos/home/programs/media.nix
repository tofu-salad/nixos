{ pkgs, ... }:
with pkgs; let
  patchStremio = pkg: appName: from: to: (lib.hiPrio (runCommand "$patched-serverjs-for-${appName}" { } ''
    ${coreutils}/bin/mkdir -p $out/opt/${appName}
    ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/opt/${appName}/server.js > $out/opt/${appName}/server.js ''));
in
{
  home.packages = (with pkgs; [
    gimp
    vlc
    obs-studio
    pamixer
    pavucontrol
    # stremio
    jellyfin-web
  ]) ++ ([
    stremio
    (patchStremio stremio "stremio" "'/usr/bin/vlc'" "${vlc}/bin/vlc")
  ]);
}
