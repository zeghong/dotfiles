# Zsh-specific history configuration

# Set HISTFILE to an XDG-compliant path
_hist_state_home=""
_hist_file=""

if [[ -n "${XDG_STATE_HOME:-}" ]]; then
    if [[ "$XDG_STATE_HOME" == /* ]]; then
        _hist_state_home="$XDG_STATE_HOME"
    else
        print -u2 -- 'zsh: warning: XDG_STATE_HOME must be an absolute path; ignoring it'
    fi
fi

if [[ -z "$_hist_state_home" && "${HOME:-}" == /* ]]; then
    _hist_state_home="$HOME/.local/state"
fi

if [[ -n "$_hist_state_home" ]]; then
    _hist_dir="$_hist_state_home/zsh"
    _hist_candidate="$_hist_dir/history"

    if [[ ! -d "$_hist_dir" ]]; then
        mkdir -p -m 700 "$_hist_dir" 2>/dev/null || :
    fi

    if [[ ! -e "$_hist_candidate" && -d "$_hist_dir" && -w "$_hist_dir" ]]; then
        (umask 077; : >> "$_hist_candidate") 2>/dev/null || :
    fi

    if [[ -f "$_hist_candidate" && -w "$_hist_candidate" ]]; then
        _hist_file="$_hist_candidate"
    fi
fi

if [[ -z "$_hist_file" ]]; then
    print -u2 -- 'zsh: warning: XDG history is unavailable; falling back to ~/.zsh_history'

    if [[ "${HOME:-}" == /* ]]; then
        _hist_candidate="$HOME/.zsh_history"

        if [[ ! -e "$_hist_candidate" && -d "$HOME" && -w "$HOME" ]]; then
            (umask 077; : >> "$_hist_candidate") 2>/dev/null || :
        fi

        if [[ -f "$_hist_candidate" && -w "$_hist_candidate" ]]; then
            _hist_file="$_hist_candidate"
        fi
    fi
fi

if [[ -n "$_hist_file" ]]; then
    HISTFILE="$_hist_file"
else
    HISTFILE=/dev/null
    print -u2 -- 'zsh: warning: persistent history is unavailable; history will not be saved'
fi

unset _hist_state_home _hist_dir _hist_candidate _hist_file

# History size limits
HISTSIZE=100000
SAVEHIST=100000

# Append commands after they finish without importing other sessions
unsetopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY INC_APPEND_HISTORY_TIME

# Use Zsh's default history file locking
unsetopt HIST_FCNTL_LOCK

# Store command timestamps and durations
setopt EXTENDED_HISTORY

# Ignore only consecutive duplicates and commands starting with a space
unsetopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE
