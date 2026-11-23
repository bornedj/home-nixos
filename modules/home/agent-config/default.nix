{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bornedj.agentConfig;
in
{
  options.bornedj.agentConfig = {
    enable = lib.mkEnableOption "the shared Claude Code configuration";

    instructions = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Agent instructions, installed as CLAUDE.md and both AGENTS.md paths.
        The shared text always comes first; hosts append their own sections
        with `lib.mkAfter`.
      '';
    };

    orchestration = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Orchestration rules referenced by the instructions.";
    };

    profile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Optional PROFILE.md installed next to the instructions.";
    };

    skills = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = ''
        Skill directories linked into ~/.claude/skills, on top of the shared
        code-review-doc skill.
      '';
    };

    tmuxHooks.enable = lib.mkEnableOption "the Claude Code tmux status hooks" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Defined here instead of as option defaults, because any host definition
    # would otherwise replace a default rather than merge with it.
    bornedj.agentConfig = {
      skills.code-review-doc = lib.mkDefault ./skills/code-review-doc;
      instructions = lib.mkBefore (builtins.readFile ./CLAUDE.md);
      orchestration = lib.mkBefore (builtins.readFile ./ORCHESTRATION.md);
    };

    # Linked per skill rather than as a whole directory because other tooling
    # (claude.ai skill sync, host-specific skill installs) also writes into
    # ~/.claude/skills.
    home.file =
      lib.mapAttrs' (
        name: source: lib.nameValuePair ".claude/skills/${name}" { inherit source; }
      ) cfg.skills
      // {
        ".claude/CLAUDE.md".text = cfg.instructions;
        ".config/agents/AGENTS.md".text = cfg.instructions;
        ".config/AGENTS.md".text = cfg.instructions;
        ".config/ORCHESTRATION.md".text = cfg.orchestration;
      }
      // lib.optionalAttrs (cfg.profile != null) {
        ".config/PROFILE.md".source = cfg.profile;
      };

    # Merges the Claude Code hooks below into ~/.claude/settings.json without
    # touching the rest of the file (settings.json is otherwise self-managed
    # by Claude Code, e.g. model/theme changes from within the app).
    home.activation.claudeTmuxHooks = lib.mkIf cfg.tmuxHooks.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
      ''
    );
  };
}
