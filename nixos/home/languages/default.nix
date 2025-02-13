{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rnix-lsp
    nixfmt
    nodejs_20
    go

    rustc
    cargo
    rust-analyzer
    rustfmt
  ];
}
