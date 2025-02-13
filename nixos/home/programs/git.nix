{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "tofu-salad";
    userEmail = "tofu salad";
    extraConfig = {
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
    };
  };
}
