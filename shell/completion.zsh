# Zsh completion system
autoload -Uz compinit

if [[ -n "${ZCOMPDUMP:-}" ]]; then
    compinit -d "$ZCOMPDUMP"
else
    compinit -D
fi
