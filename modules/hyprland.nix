{inputs, pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  environment.systemPackages = with pkgs; [
    waybar
    swaybg
    swayimg
    swaynotificationcenter
    nwg-look
    cinnamon.nemo
    lxqt.lxqt-policykit
  ];
}
