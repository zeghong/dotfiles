# Nord for Vim

An independent, dark-only Vim 9 colorscheme built from the Nord color palette.
It targets Vim rather than Neovim and follows the semantics of this dotfiles
configuration instead of copying the upstream `nord-vim` implementation.

## Loading

The colorscheme is stored as a native optional package:

```vim
if has('termguicolors')
  set termguicolors
endif
packadd nord
colorscheme nord
```

Truecolor is the primary rendering path. A curated xterm-256 fallback remains
available when the `termguicolors` option is disabled.

## Color semantics

- Polar Night colors form the editor background and layered surfaces.
- Snow Storm colors provide normal and emphasized text.
- Frost colors identify structure, functions, information, and interaction.
- Aurora colors distinguish strings, numbers, warnings, errors, and other
  attention states.

The theme defines Vim UI and syntax groups, mappings for the filetypes used by
this configuration, and highlights for the `yegappan/lsp` plugin. Semantic
function and method tokens deliberately preserve the underlying syntax color:
the plugin does not currently retain enough token modifiers to distinguish
declarations, calls, and default-library functions reliably.

## Terminal boundary

Ghostty controls the outer terminal's default colors, fonts, and ANSI palette.
This colorscheme controls Vim's editor UI and its built-in `:terminal`; it does
not detect or reconfigure the host terminal.

The built-in terminal's ANSI slots 0-15 mirror Ghostty's built-in Nord theme.
This includes its brighter slot 8 (`#596377`), which is not one of the sixteen
base Nord colors. Indexed colors 16-255 retain the standard xterm mapping, and
programs that emit 24-bit RGB retain their explicit colors.

## Known limitation

`LspStrikeThrough` declares the `strikethrough` attribute. Some terminal Vim
builds do not map the host terminal's strike capability to Vim's `t_Ts` and
`t_Te` capabilities, so the style may not be visible even when Ghostty can
render it. The colorscheme does not patch terminal capabilities.

## Testing

Run the isolated truecolor and 256-color test suites from this directory:

```sh
./test/run.sh
```

The suites cover core highlights, supported filetypes, LSP groups, quickfix,
the built-in terminal palette, colorscheme reloads, and the real Vim startup
configuration.

## Attribution

The color palette is based on Nord by Sven Greb. Its upstream notice is kept in
[`LICENSES/Nord-MIT.txt`](LICENSES/Nord-MIT.txt). This package is an unofficial,
independent Vim implementation.
