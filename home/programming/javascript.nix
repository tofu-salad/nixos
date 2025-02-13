{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_18
    nodePackages.pnpm
    yarn

    nodePackages."@prisma/language-server"
    nodePackages."@tailwindcss/language-server"
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.prisma
    # I get an LSP warning for this but still works
    # nodePackages.svelte-language-server 
    nodePackages.typescript-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver-bin
  ];
}
