{ pkgs,  inputs, ... }:

{
  # imports = [
  #   ./wired-notify
  # ];

  # wayland.windowManager.hyprland = {
  #     enable = true;
  #     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #     portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  #
  #     # systemd.enable = true;
  # };

  home.file.".config/hypr/hyprland.lua" = {
      source = ./hyprland.lua;
  };
}
