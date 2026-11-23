{ ... }:

{
  # Generated through home-manager rather than linked as a plain file so the
  # systemd session hooks are prepended; without them hyprland-session.target
  # never starts and services.hyprpaper never runs.
  wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      configType = "lua";
      extraConfig = builtins.readFile ./hyprland.lua;
  };

  services.hyprpaper.enable = true;

  home.file.".config/hypr/modules" = {
      source = ./modules;
      recursive = true;
      force = true;
  };

  home.file.".config/hypr/hyprpaper.conf".source = ./wallpapers/hyprpaper.conf;
  home.file."Pictures/wallpapers/zoro-luffy-ocean.jpg".source = ./wallpapers/zoro-luffy-ocean.jpg;
  home.file."Pictures/wallpapers/vagabond-water.jpg".source = ./wallpapers/vagabond-water.jpg;
}
