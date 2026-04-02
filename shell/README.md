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
