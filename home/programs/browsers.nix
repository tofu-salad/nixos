{ pkgs, ... }:

{
  home.programs = with pkgs; [ firefox chromium ];
}
