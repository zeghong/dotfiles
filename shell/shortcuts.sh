# Shared interactive shortcuts

case "${OSTYPE:-}" in
    darwin*)
        alias ls='command ls -G'
        alias ll='command ls -lG'
        ;;
    linux*)
        alias ls='command ls --color=auto'
        alias ll='command ls -l --color=auto'
        ;;
    *)
        alias ll='command ls -l'
        ;;
esac
