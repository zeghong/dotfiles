# Shell configuration

## Zsh setup

Set the Zsh configuration directory in `~/.zshenv`:

```zsh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
```

Link this directory to the Zsh configuration directory:

```sh
ln -s /path/to/dotfiles/shell "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
```

Configuration files are loaded explicitly from `.zshrc` to keep the startup
order predictable.

## Completion

Zsh's native completion system is initialized with `compinit`. Its cache is
stored at:

```text
${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-$ZSH_VERSION
```

If the cache directory is unavailable, Zsh prints a warning and initializes
completion without a cache.

Delete the cache and restart Zsh to rebuild it after adding or changing
completion functions:

```zsh
rm -f -- "$ZCOMPDUMP"
exec zsh
```
