{pkgs, ...}: {
  home.packages = with pkgs; [
    tree-sitter
    tmux
    # go
    rustup
    nodejs_20
    gh
    turso-cli
  ];
}
