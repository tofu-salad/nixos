{
  outputs,
  pkgs,
  ...
}:
let
  customSt =
    with pkgs;
    st.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (fetchpatch {
          url = "https://raw.githubusercontent.com/tofu-salad/.dotfiles/refs/heads/main/.config/st/tofu_st.diff";
          sha256 = "sha256-4F7irZzN2a8801h1f9OQolJjzf9YvaceKq5hARbHe1A=";
        })
      ];
    });
in
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
      nerd-fonts.ibm-plex
    ];
  };

  boot.loader.timeout = 0;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vm";
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
    customSt
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
  system.stateVersion = "24.11";

}
