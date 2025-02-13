{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
    go
    rustup
    nodejs_20
    gh
  ];
}
