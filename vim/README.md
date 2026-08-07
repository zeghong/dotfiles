# Vim Configuration

Personal Vim 9+ configuration using Vim9 script.

**Requirement:** Vim 9.0 or above

## Project Search

When available, ripgrep powers `:grep` from Vim's current working directory.
The search includes hidden files, excludes `.git`, and respects ignore files.
Without ripgrep, Vim keeps its platform-default grep configuration.

Search and navigate the quickfix results with:

```vim
:grep pattern
:copen
:cnext
:cprev
```

On Unix, use `:silent grep pattern` to avoid the hit-enter prompt produced by
the external command.

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

Navigation mappings are added to a buffer after its language server attaches:

| Mapping | Action |
| --- | --- |
| `,d` | Go to definition |
| `,r` | Show references |
| `,i` | Go to implementation |
| `,h` | Show hover information |
| `[d` | Go to the previous diagnostic |
| `]d` | Go to the next diagnostic |

Use the following command to inspect registered servers:

```vim
:LspShowAllServers
```

See [yegappan/lsp](https://github.com/yegappan/lsp) for full plugin
documentation and available language servers.
