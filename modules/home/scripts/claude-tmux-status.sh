#!/usr/bin/env zsh

# Claude Code hook target: updates tmux window options so the statusline can
# show what a Claude Code instance is doing (working/blocked/done) and a short
# description. Invoked by Claude Code hooks with the event name as $1 and the
# hook's JSON payload on stdin.

if [[ -z $TMUX ]]; then
    exit 0
fi

event=$1
input=$(cat)

win=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}' 2> /dev/null)
if [[ -z $win ]]; then
    exit 0
fi

truncate() {
    local text=$1
    text=${text//$'\n'/ }
    if [[ ${#text} -gt 40 ]]; then
        text="${text[1,40]}..."
    fi
    print -r -- "$text"
}

case $event in
    start | end)
        tmux set-option -w -t "$win" -u @claude_status 2> /dev/null
        tmux set-option -w -t "$win" -u @claude_desc 2> /dev/null
        ;;
    prompt)
        prompt=$(print -r -- "$input" | jq -r '.prompt // empty')
        tmux set-option -w -t "$win" @claude_status working
        tmux set-option -w -t "$win" @claude_desc "$(truncate "$prompt")"
        ;;
    tool)
        tool_name=$(print -r -- "$input" | jq -r '.tool_name // empty')
        tmux set-option -w -t "$win" @claude_status working
        tmux set-option -w -t "$win" @claude_desc "running: $tool_name"
        ;;
    notify)
        message=$(print -r -- "$input" | jq -r '.message // empty')
        tmux set-option -w -t "$win" @claude_status blocked
        tmux set-option -w -t "$win" @claude_desc "$(truncate "$message")"
        ;;
    stop)
        tmux set-option -w -t "$win" @claude_status done
        tmux set-option -w -t "$win" -u @claude_desc 2> /dev/null
        ;;
esac

exit 0
