# Vim Configuration

Personal Vim 9+ configuration using Vim9 script.

**Requirement:** Vim 9.0 or above

## LSP Plugin

The Vim configuration requires the `yegappan/lsp` plugin. Install it in Vim's
optional package directory:

```bash
mkdir -p ~/.config/vim/pack/vendor/opt
cd ~/.config/vim/pack/vendor/opt
git clone https://github.com/yegappan/lsp
vim -u NONE -c "helptags ~/.config/vim/pack/vendor/opt/lsp/doc" -c q
```

If the plugin is missing, Vim reports an error while loading the LSP
configuration.

## Language Servers

Language servers are configured in `plugin/lsp.vim`. Missing server
executables are skipped without preventing Vim from starting.

| Filetypes | Server |
| --- | --- |
| `go`, `gomod` | `gopls` |

Use the following command to inspect registered servers:

```vim
:LspShowAllServers
```

See [yegappan/lsp](https://github.com/yegappan/lsp) for full plugin
documentation and available language servers.
