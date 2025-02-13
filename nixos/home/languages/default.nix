{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_20
    nodePackages.pnpm
    go

    rustc
    cargo
    rust-analyzer
    rustfmt
  ];
}
