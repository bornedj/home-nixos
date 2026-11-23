{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bornedj.tmux;

  tmux = config.programs.tmux.package;

  claudeInject = pkgs.writeShellApplication {
    name = "tmux-claude-inject.sh";
    runtimeInputs = [ tmux ];
    text = builtins.readFile ./tmux-claude-inject.sh;
  };

  sessionizer = pkgs.writeShellApplication {
    name = "tmux-sessionizer.sh";
    runtimeInputs = [
      tmux
      pkgs.fzf
      pkgs.findutils
      pkgs.coreutils
      pkgs.procps
    ];
    text = ''
      list_candidates() {
        ${
          if cfg.sessionizerRoots == [ ] then
            "true"
          else
            "find ${lib.escapeShellArgs cfg.sessionizerRoots} -mindepth 1 -maxdepth 1 -type d"
        }
      }

      if [[ $# -eq 1 ]]; then
          selected=$1
      else
          selected=$(list_candidates | fzf || true)
      fi

      if [[ -z $selected ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux || true)

      if [[ -z ''${TMUX:-} ]] && [[ -z $tmux_running ]]; then
          tmux new-session -s "$selected_name" -c "$selected"
          exit 0
      fi

      if ! tmux has-session -t="$selected_name" 2> /dev/null; then
          tmux new-session -ds "$selected_name" -c "$selected"
      fi

      tmux switch-client -t "$selected_name"
    '';
  };

  sessionBinds = lib.pipe cfg.sessions [
    (lib.filter (s: s.key != null))
    (lib.concatMapStringsSep "\n" (
      s: "bind-key ${s.key} attach-session -t ${lib.escapeShellArg s.name} -c ${lib.escapeShellArg s.dir}"
    ))
  ];
in
{
  options.bornedj.tmux = {
    enable = lib.mkEnableOption "the shared tmux configuration";

    sessions = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Session name.";
            };
            dir = lib.mkOption {
              type = lib.types.str;
              description = "Absolute path the session starts in. A leading ~ is not expanded.";
            };
            key = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Key bound after the prefix to attach to the session. No bind when null.";
            };
          };
        }
      );
      default = [ ];
      description = "Frequently used sessions. Each gets a bind (when it has a key) and a line in tmux-session-init.sh.";
    };

    sessionizerRoots = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Absolute paths whose direct children tmux-sessionizer.sh offers as sessions. A leading ~ is not expanded.";
    };

    sessionizerPackage = lib.mkOption {
      type = lib.types.package;
      default = sessionizer;
      readOnly = true;
      internal = true;
      description = "The generated tmux-sessionizer.sh, shared with the scripts module so it is built once.";
    };

    claudeStatus.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Show the Claude Code agent status in the window list and status line of whatever theme the host loads.";
    };
  };

  config = lib.mkIf cfg.enable { };
}
