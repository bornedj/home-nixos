{ pkgs,  inputs, ... }:

{
  # imports = [
  #   ./wired-notify
  # ];

  wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  home.file.".config/hypr/hyprland.lua" = {
      source = ./hyprland.lua;
      force = true;
  };
  home.file.".config/hypr/hyprland-config" = {
      source = ./hyprland-config;
      recursive = true;
      force = true;
  };
}
