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

def ConfigureLspNavigation()
  nnoremap <buffer> <silent> <leader>d <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> <silent> <leader>r <Cmd>LspShowReferences<CR>
  nnoremap <buffer> <silent> <leader>i <Cmd>LspGotoImpl<CR>
  nnoremap <buffer> <silent> <leader>h <Cmd>LspHover<CR>
enddef

augroup lsp_navigation
  autocmd!
  autocmd User LspAttached ConfigureLspNavigation()
augroup END
