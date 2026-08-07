vim9script

# Keep persistent state outside the configuration directory.
def Warn(message: string)
  echohl WarningMsg
  echomsg 'Vim state: ' .. message
  echohl None
enddef

def ResolveStateDir(): string
  if !empty($XDG_STATE_HOME)
    if isabsolutepath($XDG_STATE_HOME)
      return substitute($XDG_STATE_HOME, '/\+$', '', '') .. '/vim'
    endif
    Warn('XDG_STATE_HOME must be absolute; using the default location')
  endif

  if isabsolutepath($HOME)
    return substitute($HOME, '/\+$', '', '') .. '/.local/state/vim'
  endif
  return ''
enddef

def EnsureDirectory(path: string): bool
  try
    return mkdir(path, 'p', 0o700) && filewritable(path) == 2
  catch
    return false
  endtry
enddef

var state_dir = ResolveStateDir()

# Disable affected persistence instead of falling back to Vim's default paths.
if !empty(state_dir) && EnsureDirectory(state_dir)
  if empty(&viminfofile)
    &viminfofile = state_dir .. '/viminfo'
  endif

  g:netrw_home = state_dir
else
  Warn('managed state directory is unavailable')
  if empty(&viminfofile)
    &viminfofile = 'NONE'
  endif
  g:netrw_dirhistmax = 0
endif
