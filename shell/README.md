# Shell configuration

Both Bash and Zsh load configuration files explicitly to keep their startup
order predictable.

## Shared configuration

`$HOME/.local/bin` is added to the front of `PATH` for user-specific
executables. This directory is defined by the
[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/).

## Bash setup

Source the Bash configuration from `~/.bashrc`:

```bash
source /path/to/dotfiles/shell/.bashrc
```

### Bash history

Bash history is stored at `$XDG_STATE_HOME/bash/history`, defaulting to
`$HOME/.local/state/bash/history`. New directories and files use permissions
`0700` and `0600`, respectively; existing permissions are left unchanged.

If the XDG location is unavailable, history falls back to `$HOME/.bash_history`.
If neither location is usable, `HISTFILE` is set to `/dev/null` and persistent
history is disabled for that shell.

## Zsh setup

Set the Zsh configuration directory in `~/.zshenv`:

```zsh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
```

Link this directory to the Zsh configuration directory:

```sh
ln -s /path/to/dotfiles/shell "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
```

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
