{ lib, ... }:
{
  options.bornedj.git.enable = lib.mkEnableOption "the shared git and gh configuration";
}
