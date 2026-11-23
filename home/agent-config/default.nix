{ lib, pkgs, ... }:

let
  # Linked per skill rather than as a whole directory because other tooling
  # (claude.ai skill sync, skills installed by plugins) also writes into
  # ~/.claude/skills, and a read-only directory symlink would break that.
  skillFiles = lib.mapAttrs'
    (name: _: lib.nameValuePair ".claude/skills/${name}" {
      source = ./skills + "/${name}";
    })
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./skills));

  # Event name -> argument for claude-tmux-status.sh.
  tmuxStatusEvents = {
    SessionStart = "start";
    UserPromptSubmit = "prompt";
    PreToolUse = "tool";
    Notification = "notify";
    Stop = "stop";
    SessionEnd = "end";
  };

  tmuxHooks = lib.mapAttrs
    (event: arg: [
      ({
        hooks = [{
          type = "command";
          command = "$HOME/.local/bin/claude-tmux-status.sh ${arg}";
        }];
      } // lib.optionalAttrs (event == "PreToolUse") { matcher = "*"; })
    ])
    tmuxStatusEvents;

  tmuxHooksFile = pkgs.writeText "claude-tmux-hooks.json" (builtins.toJSON tmuxHooks);
in
{
  # claude user configuration
  home.file = skillFiles // {
    ".claude/CLAUDE.md".source = ./CLAUDE.md;
    ".config/agents/AGENTS.md".source = ./CLAUDE.md;
    ".config/AGENTS.md".source = ./CLAUDE.md;
    ".config/PROFILE.md".source = ./PROFILE.md;
    ".config/ORCHESTRATION.md".source = ./ORCHESTRATION.md;
  };

  # Claude Code rewrites settings.json itself (model, theme, user hooks), so
  # only the tmux status hook entries are merged in. Entries from an earlier
  # run are dropped first, which keeps the merge idempotent and leaves every
  # other key and hook alone. Failures only warn: a broken settings.json must
  # not abort the whole home-manager activation.
  home.activation.claudeTmuxHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Resolve symlinks so the write goes through to the real file.
    settings="$(${pkgs.coreutils}/bin/readlink -f "$HOME/.claude/settings.json")"
    mkdir -p "$(dirname "$settings")"
    tmp="$(${pkgs.coreutils}/bin/mktemp "$settings.XXXXXX")"

    if { if [ -s "$settings" ]; then cat "$settings"; else echo '{}'; fi; } \
        | ${pkgs.jq}/bin/jq --slurpfile ours ${tmuxHooksFile} -f ${./merge-hooks.jq} > "$tmp"; then
      [ ! -e "$settings" ] || ${pkgs.coreutils}/bin/chmod --reference="$settings" "$tmp"
      mv "$tmp" "$settings"
    else
      rm -f "$tmp"
      echo "claudeTmuxHooks: could not merge hooks into $settings, leaving it unchanged" >&2
    fi
  '';
}
