# Bash-specific history configuration

# Set HISTFILE to XDG-compliant path
_hist_dir="${XDG_STATE_HOME:-$HOME/.local/state}/bash"
[[ ! -d "$_hist_dir" ]] && mkdir -p "$_hist_dir"
HISTFILE="$_hist_dir/history"
unset _hist_dir

# Append to history file instead of overwriting
shopt -s histappend

# Write history after every command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

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
