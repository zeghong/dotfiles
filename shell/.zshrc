# Shell configuration loader
# This file is used as $ZDOTDIR/.zshrc

# Get the directory where this script resides
_shell_root="${${(%):-%N}:A:h}"

# Load shared configuration explicitly to keep startup order predictable
source "$_shell_root/go.sh"

# Initialize Zsh completion after configuring its cache
source "$_shell_root/cache.zsh"
source "$_shell_root/completion.zsh"

# Cleanup temporary variable
unset _shell_root
