{ lib, ... }:
{
  options.bornedj.cli.enable = lib.mkEnableOption "the shared command line packages";
}
