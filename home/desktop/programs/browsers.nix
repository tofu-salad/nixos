{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
    };

    firefox = { enable = true; };
  };
  home.packages = with pkgs; [
    google-chrome
  ];
}
