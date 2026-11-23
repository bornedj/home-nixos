# Host facts the shared modules need. Each host sets these once; modules read
# them instead of hardcoding paths, so the same module serves every machine.
{ lib, ... }:
{
  options.bornedj = {
    flake = {
      dir = lib.mkOption {
        type = lib.types.str;
        description = "Checkout of the flake that builds this host, used by the update alias and the configs tmux session.";
      };
      host = lib.mkOption {
        type = lib.types.str;
        description = "Attribute name under nixosConfigurations that builds this host.";
      };
    };

    workspace = {
      reposDir = lib.mkOption {
        type = lib.types.str;
        description = "Directory holding the repositories worked on from this host.";
      };
      clipboardCommand = lib.mkOption {
        type = lib.types.str;
        default = "wl-copy";
        description = "Command that copies stdin to the system clipboard.";
      };
    };
  };
}
