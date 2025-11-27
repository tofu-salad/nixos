{
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = [ ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''autologin-user=tofu'';

  environment.pathsToLink = [ "/libexec" ];
  fhs.enable = true;
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
      "autologin"
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
  system.stateVersion = "24.11";
}
