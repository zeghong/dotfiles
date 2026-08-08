vim9script

augroup NordTest
  autocmd!
  autocmd BufWritePost * echo 'saved'
augroup END

def Render(value: string): number
  return len(value)
enddef

nnoremap <leader>n :echo 'nord'<CR>
