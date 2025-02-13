{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
      commandLineArgs =
        [ "--force-dark-mode" "--enable-features=WebUIDarkMode" ];
    };

    firefox = { enable = true; };
  };
}
