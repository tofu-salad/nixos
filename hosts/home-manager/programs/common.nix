{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    tree
    bat
    fd
    fzf
    jq
    tmux
    unzip

    openssl
    ripgrep

    curl
    eza
    tmux

    # gcc
    neofetch

    adwaita-qt
    adwaita-qt6
  ];
}
