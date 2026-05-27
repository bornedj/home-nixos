{ pkgs,  inputs, ... }:

{
  # imports = [
  #   ./wired-notify
  # ];

  wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
  };

  services.hyprpaper.enable = true;

  home.file.".config/hypr/hyprland.lua" = {
      source = ./hyprland.lua;
      force = true;
  };
  home.file.".config/hypr/hyprland-config" = {
      source = ./hyprland-config;
      recursive = true;
      force = true;
  };
  home.file.".config/hypr/hyprpaper.conf" = {
      source = ./hyprland-config/hyprpaper.conf;
      recursive = true;
      force = true;
  };
}
