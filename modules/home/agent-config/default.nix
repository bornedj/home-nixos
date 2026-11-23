{ lib, ... }:
{
  options.bornedj.agentConfig.enable = lib.mkEnableOption "the shared Claude Code configuration";
}
