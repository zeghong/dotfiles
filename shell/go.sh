# Go development environment

_go_data_home=""
_go_cache_home=""

case "${XDG_DATA_HOME:-}" in
    /*)
        _go_data_home="$XDG_DATA_HOME"
        ;;
    "")
        case "${HOME:-}" in
            /*) _go_data_home="$HOME/.local/share" ;;
            *) printf '%s\n' 'shell: warning: Go data directory is unavailable; GOPATH unchanged' >&2 ;;
        esac
        ;;
    *)
        printf '%s\n' 'shell: warning: XDG_DATA_HOME must be an absolute path; ignoring it' >&2
        case "${HOME:-}" in
            /*) _go_data_home="$HOME/.local/share" ;;
            *) printf '%s\n' 'shell: warning: Go data directory is unavailable; GOPATH unchanged' >&2 ;;
        esac
        ;;
esac

if [ -n "$_go_data_home" ]; then
    export GOPATH="$_go_data_home/go"
fi

case "${HOME:-}" in
    /*) export GOBIN="$HOME/.local/bin" ;;
    *) printf '%s\n' 'shell: warning: HOME must be an absolute path; GOBIN unchanged' >&2 ;;
esac

case "${OSTYPE:-}" in
    darwin*)
        case "${HOME:-}" in
            /*) _go_cache_home="$HOME/Library/Caches" ;;
            *) printf '%s\n' 'shell: warning: Go cache directory is unavailable; GOMODCACHE unchanged' >&2 ;;
        esac
        ;;
    *)
        case "${XDG_CACHE_HOME:-}" in
            /*)
                _go_cache_home="$XDG_CACHE_HOME"
                ;;
            "")
                case "${HOME:-}" in
                    /*) _go_cache_home="$HOME/.cache" ;;
                    *) printf '%s\n' 'shell: warning: Go cache directory is unavailable; GOMODCACHE unchanged' >&2 ;;
                esac
                ;;
            *)
                printf '%s\n' 'shell: warning: XDG_CACHE_HOME must be an absolute path; ignoring it' >&2
                case "${HOME:-}" in
                    /*) _go_cache_home="$HOME/.cache" ;;
                    *) printf '%s\n' 'shell: warning: Go cache directory is unavailable; GOMODCACHE unchanged' >&2 ;;
                esac
                ;;
        esac
        ;;
esac

if [ -n "$_go_cache_home" ]; then
    export GOMODCACHE="$_go_cache_home/go-mod"
fi

unset _go_data_home _go_cache_home
