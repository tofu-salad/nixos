{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  environment.pathsToLink = [ "/libexec" ];
  fhs.enable = true;
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
      ];
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "IosevkaTerm"
        ];
      })
    ];
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vm"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Argentina/Cordoba";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  users.users.tofu = {
    isNormalUser = true;
    description = "tofu";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    direnv
    eza
    fd
    fzf
    gcc
    gh
    git
    jq
    mako
    neovim
    ripgrep
    tmux
    tree
    unzip
    vim
    wget
    xclip
    xterm
  ];
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.clipboard = true;
  system.stateVersion = "24.11"; # Did you read the comment?

}
