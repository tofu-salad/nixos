{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
      commandLineArgs = [ "--enable-features=UseOzonePlatform --ozone-platform=wayland" ];
    };

    firefox = { enable = true; };
  };
  home.packages = with pkgs; [
    google-chrome
  ];
}
