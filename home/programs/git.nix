{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "zeroCalSoda";
    userEmail = "diego.ezequiel.scardulla@gmail.com";
    extraConfig = {
      color = { ui = "auto"; };
      init = { defaultBranch = "main"; };
      pull = { rebase = false; };
    };
  };
}
