{ lib, pkgs, ... }:

{
  programs.tmux.extraConfig = lib.mkOrder 1000 ''
    source-file ~/.config/tmux/tmux-colors.conf
    # dotbar reads the @tmux-dotbar-* options the colour file sets, so it has to
    # run after it.
    run-shell ${pkgs.tmuxPlugins.dotbar.rtp}
  '';
}
