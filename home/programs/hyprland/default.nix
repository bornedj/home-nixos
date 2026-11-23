{ ... }:

{
  wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      # home-manager switched the default to "lua" and warns while
      # stateVersion is below 26.05. The lua config here is written by
      # home.file below, so the generated file stays hyprland.conf.
      configType = "hyprlang";
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

  home.file.".config/hypr/hyprpaper.conf".source = ./wallpapers/hyprpaper.conf;
  home.file."Pictures/wallpapers/zoro-luffy-ocean.jpg".source = ./wallpapers/zoro-luffy-ocean.jpg;
  home.file."Pictures/wallpapers/vagabond-water.jpg".source = ./wallpapers/vagabond-water.jpg;
}
