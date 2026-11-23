{ lib, ... }:
{
  options.bornedj.tmux.enable = lib.mkEnableOption "the shared tmux configuration";
}
