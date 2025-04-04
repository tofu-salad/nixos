{
  programs.git = {
    enable = true;
    userName = "tofu-salad";
    userEmail = "67925799+tofu-salad@users.noreply.github.com";
    extraConfig = {
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
