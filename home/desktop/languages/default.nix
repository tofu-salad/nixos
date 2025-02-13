{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
    rnix-lsp nixfmt 
    nodejs_20
	rustc
	cargo
    go
    ];
}
