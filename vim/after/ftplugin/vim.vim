vim9script

# Use 2 spaces for indentation
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

# Preserve existing undo ftplugin if present
if exists('b:undo_ftplugin')
    b:undo_ftplugin ..= ' | setlocal tabstop< shiftwidth< expandtab<'
else
    b:undo_ftplugin = 'setlocal tabstop< shiftwidth< expandtab<'
endif
