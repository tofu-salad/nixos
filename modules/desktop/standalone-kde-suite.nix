{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.standaloneKdeSuite;

  dolphinFixed = pkgs.kdePackages.dolphin.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/dolphin \
        --prefix XDG_CONFIG_DIRS : "${pkgs.kdePackages.kservice}/etc/xdg" \
        --run "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental || true"
    '';
  });

in
{
  options.desktop.standaloneKdeSuite = {
    enable = mkEnableOption "standalone KDE/Qt applications + plumbing";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs.kdePackages;
      [
        qtsvg
        breeze
        dolphinFixed
        filelight
        ark
        gwenview
        okular
        kcalc
        kcharselect
        kate
        kio-extras
      ]
      ++ [
        pkgs.font-manager
        pkgs.gnome-disk-utility
      ];

    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];

    services.gnome.gnome-keyring.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
