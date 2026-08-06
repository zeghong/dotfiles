# Zsh cache files
_zsh_cache_home=""
_zsh_cache_dir=""

if [[ -n "${XDG_CACHE_HOME:-}" ]]; then
    if [[ "$XDG_CACHE_HOME" == /* ]]; then
        _zsh_cache_home="$XDG_CACHE_HOME"
    else
        print -u2 -- 'zsh: warning: XDG_CACHE_HOME must be an absolute path; ignoring it'
    fi
fi

if [[ -z "$_zsh_cache_home" && "${HOME:-}" == /* ]]; then
    _zsh_cache_home="$HOME/.cache"
fi

if [[ -n "$_zsh_cache_home" ]]; then
    _zsh_cache_dir="$_zsh_cache_home/zsh"
fi

if [[ -n "$_zsh_cache_dir" && ! -d "$_zsh_cache_dir" ]]; then
    mkdir -p "$_zsh_cache_dir" 2>/dev/null
fi

if [[ -n "$_zsh_cache_dir" && -d "$_zsh_cache_dir" && -w "$_zsh_cache_dir" ]]; then
    typeset -g ZCOMPDUMP="$_zsh_cache_dir/.zcompdump-$ZSH_VERSION"
    typeset +x ZCOMPDUMP
else
    unset ZCOMPDUMP
    print -u2 -- 'zsh: warning: cache directory is unavailable; completion caching disabled'
fi

unset _zsh_cache_home _zsh_cache_dir
