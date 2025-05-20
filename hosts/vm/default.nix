{
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "tofu"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  environment.pathsToLink = [ "/libexec" ];
  fhs.enable = true;
  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
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
  boot.loader.timeout = 0;
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
    ripgrep
    st
    stow
    tmux
    tree
    unstable.neovim
    unzip
    vim
    wget
    xclip
  ];

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.clipboard = true;
  system.stateVersion = "24.11"; # Did you read the comment?

}
