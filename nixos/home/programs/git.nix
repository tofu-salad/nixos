{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "tofu-salad";
    userEmail = "soda.zero.sip@proton.me";
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
