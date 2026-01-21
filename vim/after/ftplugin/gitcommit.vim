" Disable line numbers for git commits
setlocal nonumber

" Preserve existing undo ftplugin if present
if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= ' | setlocal number<'
else
    let b:undo_ftplugin = 'setlocal number<'
endif
