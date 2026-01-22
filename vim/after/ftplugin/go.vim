vim9script

# Go filetype plugin
setlocal noexpandtab tabstop=4 shiftwidth=0 softtabstop=0

# Preserve existing undo ftplugin if present
if exists('b:undo_ftplugin')
    b:undo_ftplugin ..= ' | setlocal expandtab< tabstop< shiftwidth< softtabstop<'
else
    b:undo_ftplugin = 'setlocal expandtab< tabstop< shiftwidth< softtabstop<'
endif
