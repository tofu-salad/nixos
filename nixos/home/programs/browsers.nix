{  pkgs, ... }:
{

  home.packages = with pkgs; [
    google-chrome
  ];
  programs = {
    firefox = {
      enable = false;
    };
  };
}
