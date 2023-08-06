{ pkgs, ... }:

let my-pkgs = ps: with ps; [ pandas ];
in { home.packages = with pkgs; [ (python3.withPackages my-pkgs) ]; }
