{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
    rnix-lsp nixfmt 
    nodejs_20
    rustup
    go
    ];
}
