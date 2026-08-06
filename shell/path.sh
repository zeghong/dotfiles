# Shared PATH configuration

case "${HOME:-}" in
    /*)
        _local_bin="$HOME/.local/bin"

        case ":${PATH:-}:" in
            *":$_local_bin:"*) ;;
            *) PATH="$_local_bin${PATH:+:$PATH}" ;;
        esac

        export PATH
        unset _local_bin
        ;;
    "")
        printf '%s\n' 'shell: warning: HOME is unset; local bin not added to PATH' >&2
        ;;
    *)
        printf '%s\n' 'shell: warning: HOME must be an absolute path; local bin not added to PATH' >&2
        ;;
esac
