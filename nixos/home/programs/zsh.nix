{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.22.0";
          sha256 = "sha256-TR4CyBZ+KoZRs9XDmWE5lJuUXXU1J8E2Z63nt+FS+5w=";
        };
      }

    ];
    shellAliases = {
      # ls = "exa -al --color=always --group-directories-first";
      # ll = "ls -l";
      vim = "nvim";
      dotfiles = "$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 10000;
    };
    initExtra = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
      export VISUAL=vim
      export EDITOR="$VISUAL"
      export GIT_EDITOR=vim
      export PATH=$PATH:/usr/local/go/bin
      export PATH=$PATH:$HOME/go/bin/
    '';
  };
}
