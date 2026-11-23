{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bornedj.scripts;

  sessionInit = pkgs.writeShellApplication {
    name = "tmux-session-init.sh";
    runtimeInputs = [ config.programs.tmux.package ];
    # Each session is independent; one failing must not skip the rest.
    bashOptions = [
      "nounset"
      "pipefail"
    ];
    text = lib.concatMapStringsSep "\n" (
      s: "tmux new-session -t ${lib.escapeShellArg s.name} -c ${lib.escapeShellArg s.dir}"
    ) config.bornedj.tmux.sessions;
  };

  linkInto = drv: name: {
    ".local/bin/${name}".source = "${drv}/bin/${name}";
  };
in
{
  # The sessions and the sessionizer the scripts are built from.
  imports = [ ../tmux ];

  options.bornedj.scripts.enable = lib.mkEnableOption "the shared tmux and Claude Code helper scripts";

  config = lib.mkIf cfg.enable {
    home.file =
      linkInto config.bornedj.tmux.sessionizerPackage "tmux-sessionizer.sh"
      // linkInto sessionInit "tmux-session-init.sh"
      // {
        # Claude Code hooks call this by path; it stays a zsh script because it
        # leans on zsh string slicing.
        ".local/bin/claude-tmux-status.sh" = {
          source = ./claude-tmux-status.sh;
          executable = true;
        };
      };
  };
}
