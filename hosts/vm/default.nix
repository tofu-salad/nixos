{
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  environment.pathsToLink = [ "/libexec" ];
  fhs.enable = true;

  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      initial_session = {
        command = "startx";
        user = "tofu";
      };
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/greetd --cmd startx";
      };
    };
  };
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = [ ];
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  fonts = {
    packages = with pkgs; [
      adwaita-fonts
    ];
  };

  boot.loader.timeout = 0;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vm";
  networking.networkmanager.enable = true;
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
    alacritty
    btop
    curl
    direnv
    fd
    fzf
    gcc
    gh
    git
    jq
    mako
    ripgrep
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
