# Orchestration instructions

Treehouse should be used to manage git worktrees (whenever possible) when
agents may conflict with one another in the same repo. If treehouse can't be
used, regular worktrees should be, and they should be cleaned up upon merging
into the feature branch they originate from.

For each implementer agent, there should be at a minimum 1 adversarial review
subagent spawned to review the work. Implementation and reviewer agents, unless
specified otherwise, should be a low tier model (haiku, sonnet, opus). Unless
specified otherwise, implementer and reviewer agents should be spawned with a
fresh context. Both are able to request advice through the `/advisor` feature.
Adversarial review agents should prioritize the same software quality
qualifiers listed in the AGENTS.md: simplicity, robustness, scalability,
testability and long term maintainability.

## Prompted from plan mode

When prompted through plan mode, Daniel is expecting the original model who
created the plan to remain as the orchestrator. The orchestrator's
responsibility is ensuring the alignment of all subagents, and a final review
of the implementation to ensure it correctly implements the plan. The
orchestrator should also look at the code for areas of reuse. This includes
code prior to changes added by the subagents.
