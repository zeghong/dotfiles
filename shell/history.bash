# Bash-specific history configuration

# Set HISTFILE to XDG-compliant path
_hist_state_home=""
_hist_file=""

if [[ -n "${XDG_STATE_HOME:-}" ]]; then
    if [[ "$XDG_STATE_HOME" == /* ]]; then
        _hist_state_home="$XDG_STATE_HOME"
    else
        printf '%s\n' 'bash: warning: XDG_STATE_HOME must be an absolute path; ignoring it' >&2
    fi
fi

if [[ -z "$_hist_state_home" && "${HOME:-}" == /* ]]; then
    _hist_state_home="$HOME/.local/state"
fi

if [[ -n "$_hist_state_home" ]]; then
    _hist_dir="$_hist_state_home/bash"
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
    printf '%s\n' 'bash: warning: XDG history is unavailable; falling back to ~/.bash_history' >&2

    if [[ "${HOME:-}" == /* ]]; then
        _hist_candidate="$HOME/.bash_history"

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
    printf '%s\n' 'bash: warning: persistent history is unavailable; history will not be saved' >&2
fi

unset _hist_state_home _hist_dir _hist_candidate _hist_file

# Append to history file instead of overwriting
shopt -s histappend

# Write history after every command without duplicating the prompt hook
_history_append_pattern='(^|;)[[:space:]]*history[[:space:]]+-a[[:space:]]*($|;)'
_history_append_configured=false
_prompt_command_declaration="$(declare -p PROMPT_COMMAND 2>/dev/null || :)"

case "$_prompt_command_declaration" in
    "declare -a "*)
        for _prompt_command in "${PROMPT_COMMAND[@]}"; do
            if [[ "$_prompt_command" =~ $_history_append_pattern ]]; then
                _history_append_configured=true
                break
            fi
        done

        if [[ "$_history_append_configured" == false ]]; then
            PROMPT_COMMAND=("history -a" "${PROMPT_COMMAND[@]}")
        fi
        ;;
    *)
        if [[ "${PROMPT_COMMAND:-}" =~ $_history_append_pattern ]]; then
            _history_append_configured=true
        fi

        if [[ "$_history_append_configured" == false ]]; then
            PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
        fi
        ;;
esac

unset _history_append_pattern _history_append_configured
unset _prompt_command_declaration _prompt_command

# Maximum number of lines to keep in history
HISTSIZE=50000

# Maximum number of lines to keep in history file
HISTFILESIZE=100000

# Ignore duplicate commands and commands starting with space
HISTCONTROL=ignoreboth

# Add timestamps to history
HISTTIMEFORMAT="%F %T "

# Ignore some common commands
HISTIGNORE="&:ls:cd:cd -:pwd:exit:bg:fg:history:clear"
