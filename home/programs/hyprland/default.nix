{ pkgs,  inputs, ... }:

{
  wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
  };

  services.hyprpaper.enable = true;

  home.file.".config/hypr/hyprland.lua" = {
      source = ./hyprland.lua;
      force = true;
  };
  home.file.".config/hypr/modules" = {
      source = ./modules;
      recursive = true;
      force = true;
  };
}
