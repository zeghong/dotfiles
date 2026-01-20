# Shell configuration loader
# This file should be sourced from $HOME/.bashrc

# Get the directory where THIS script resides
_shell_root="$(command cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && command pwd)"

# Load configuration files if the directory exists
if [ -d "$_shell_root" ]; then
    # Source .sh files (POSIX compatible configuration)
    for _file in "$_shell_root"/*.sh; do
        [ -f "$_file" ] && . "$_file"
    done

    # Source .bash files (bash-specific configuration)
    for _file in "$_shell_root"/*.bash; do
        [ -f "$_file" ] && . "$_file"
    done
fi

# Cleanup temporary variables
unset _shell_root _file
