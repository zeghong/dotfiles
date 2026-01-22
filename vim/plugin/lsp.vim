vim9script

packadd lsp

# LSP servers
var gopls = {
  name: 'gopls',
  filetype: ['go', 'gomod'],
  path: 'gopls',
  args: ['serve'],
}

call LspAddServer([gopls])
