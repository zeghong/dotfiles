# Vim Configuration

Personal Vim 9+ configuration using Vim9 script.

**Requirement:** Vim 9.0 or above

## LSP Plugin

Install the `yegappan/lsp` plugin:

```bash
mkdir -p ~/.config/vim/pack/vendor/opt
cd ~/.config/vim/pack/vendor/opt
git clone https://github.com/yegappan/lsp
vim -u NONE -c "helptags ~/.config/vim/pack/vendor/opt/lsp/doc" -c q
```

Enable LSP for a filetype by adding a server configuration to your vimrc:

```vim
vim9script

# Example: Go language server
LspAddServer([{
    name: 'gopls',
    filetype: ['go', 'gomod'],
    path: '/usr/local/bin/gopls',
    args: ['serve'],
}])
```

See [yegappan/lsp](https://github.com/yegappan/lsp) for full documentation and available language servers.
