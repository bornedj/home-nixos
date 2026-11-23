{ lib, ... }:
{
  imports = [ ../options.nix ];
  options.bornedj.zsh.enable = lib.mkEnableOption "the shared zsh configuration";
}
