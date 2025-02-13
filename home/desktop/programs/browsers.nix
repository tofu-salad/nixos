{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
    };

  };
  home.packages = with pkgs; [
    google-chrome
  ];
}
