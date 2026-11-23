{ pkgs, ... }:

{
  programs.zsh = {
    oh-my-zsh.theme = "fwalch";

    shellAliases.source-color = "matugen image ~/Pictures/wallpapers/vagabond-water.jpg --source-color-index 1 --show-colors";

    loginExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          start-hyprland
      fi
      tmux source ~/.config/tmux/tmux.conf
    '';

    sessionVariables.QMLLS_BUILD_DIRS = "${pkgs.quickshell}/bin";
  };
}
