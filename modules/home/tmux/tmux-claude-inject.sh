# Adds the Claude Code agent status to whatever theme tmux has loaded: the dot
# goes in front of the window name of each window format and the segment at the
# start of the status line. Themes differ in their formats, so this edits the
# live values instead of carrying a copy of each theme. The conf re-runs this on
# every reload, so a value that already has the marker is left alone.

dot='#{E:@bornedj_claude_dot}'
segment='#{E:@bornedj_claude_segment}'
window_name='#W'
style_start='#['

# The dot sets its own colour, so in a theme like Nord it has to sit before the
# style run that precedes the window name; otherwise the name would inherit the
# dot colour. dotbar has no style run before #W, so there the window name takes
# the dot colour; the hop only matters for themes like Nord.
# The last window name is the one that is shown for a plain window: dotbar puts
# an ssh-only branch with its own #W inside a #() call ahead of it.
inject_dot() {
    local option=$1
    local value before after head style
    value=$(tmux show -gv "$option")

    if [[ $value == *"$dot"* ]] || [[ $value != *"$window_name"* ]]; then
        return 0
    fi

    before=${value%"$window_name"*}
    after=${value#"$before"}

    head=${before%"$style_start"*}
    style=${before#"$head"}
    if [[ $before == *"$style_start"* ]] && [[ $style == "$style_start"*"]" ]] && [[ -z ${style#*]} ]]; then
        before=$head
        after=$style$after
    fi

    tmux set -g "$option" "$before$dot$after"
}

inject_segment() {
    local value
    value=$(tmux show -gv status-right)

    if [[ $value == *"$segment"* ]]; then
        return 0
    fi

    tmux set -g status-right "$segment$value"
}

inject_dot window-status-format
inject_dot window-status-current-format
inject_segment
