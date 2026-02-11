vim9script

packadd lsp

# LSP servers
var gopls = {
  name: 'gopls',
  filetype: ['go', 'gomod'],
  path: 'gopls',
  args: ['serve'],
}


var options = {
  'ignoreMissingServer': true,
}

call LspOptionsSet(options)
call LspAddServer([gopls])
