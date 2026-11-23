# $ours comes from --slurpfile, so it is a one-element array.
def ownedByTmuxStatus:
  (.hooks // []) | any((.command // "") | contains("claude-tmux-status.sh"));

reduce ($ours[0] | keys[]) as $event (
  . // {};
  .hooks[$event] = (
    ((.hooks[$event] // []) | map(select(ownedByTmuxStatus | not)))
    + $ours[0][$event]
  )
)
