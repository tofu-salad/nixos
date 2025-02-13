{ pkgs, ... }:

{
  home.packages = with pkgs; [
#    rnix-lsp
    nixfmt
    nodejs_20
    nodePackages.pnpm
    go

    rustc
    cargo
    rust-analyzer
    rustfmt
  ];
}
