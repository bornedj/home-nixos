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

  # Merges the Claude Code hooks below into ~/.claude/settings.json without
  # touching the rest of the file (settings.json is otherwise self-managed
  # by Claude Code, e.g. model/theme changes from within the app).
  home.activation.claudeTmuxHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    [ -f "$settings" ] || echo '{}' > "$settings"
    hooks='{
        "SessionStart": [
            { "hooks": [ { "type": "command", "command": "$HOME/.local/bin/claude-tmux-status.sh start" } ] }
        ],
        "UserPromptSubmit": [
            { "hooks": [ { "type": "command", "command": "$HOME/.local/bin/claude-tmux-status.sh prompt" } ] }
        ],
        "PreToolUse": [
            { "matcher": "*", "hooks": [ { "type": "command", "command": "$HOME/.local/bin/claude-tmux-status.sh tool" } ] }
        ],
        "Notification": [
            { "hooks": [ { "type": "command", "command": "$HOME/.local/bin/claude-tmux-status.sh notify" } ] }
        ],
        "Stop": [
            { "hooks": [ { "type": "command", "command": "$HOME/.local/bin/claude-tmux-status.sh stop" } ] }
        ],
        "SessionEnd": [
            { "hooks": [ { "type": "command", "command": "$HOME/.local/bin/claude-tmux-status.sh end" } ] }
        ]
    }'
    ${pkgs.jq}/bin/jq --argjson h "$hooks" '.hooks = $h' "$settings" > "$settings.tmp" \
        && mv "$settings.tmp" "$settings"
  '';

}
