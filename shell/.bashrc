# Shell configuration loader
# This file should be sourced from $HOME/.bashrc

# Get the directory where this script resides
_shell_root="$(command cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && command pwd)"

# Load shared configuration before Bash-specific configuration
source "$_shell_root/go.sh"
source "$_shell_root/history.bash"

# Cleanup temporary variable
unset _shell_root
