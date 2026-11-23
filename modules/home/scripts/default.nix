{ lib, ... }:
{
  options.bornedj.scripts.enable = lib.mkEnableOption "the shared tmux and Claude Code helper scripts";
}
