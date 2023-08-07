{ pkgs, config, ... }:

{
  programs = {
    chromium = {
      enable = true;
      commandLineArgs = [
        "--force-dark-mode"
        "--enable-features=WebUIDarkMode"
        "--enable-blink-features=MiddleClickAutoscroll"
      ];
    };

    firefox = { enable = true; };
  };
}
