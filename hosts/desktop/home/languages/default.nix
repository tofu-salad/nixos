{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_20
    go
    rustc
    cargo
  ];
}
