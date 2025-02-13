{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };

  };
  home.packages = with pkgs; [
    google-chrome
  ];
}
