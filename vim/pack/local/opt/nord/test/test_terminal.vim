vim9script

import './helpers.vim' as test

v:errors = []

const PACKAGE_ROOT = expand('<script>:p:h:h')
execute $'set runtimepath^={fnameescape(PACKAGE_ROOT)}'

const MODE = getenv('NORD_TEST_MODE')
if MODE ==# 'truecolor'
  set termguicolors
elseif MODE ==# 'cterm'
  set notermguicolors
else
  assert_report($'unknown NORD_TEST_MODE: {MODE}')
endif

colorscheme nord

const ANSI = [
  '#3b4252', '#bf616a', '#a3be8c', '#ebcb8b',
  '#81a1c1', '#b48ead', '#88c0d0', '#e5e9f0',
  '#596377', '#bf616a', '#a3be8c', '#ebcb8b',
  '#81a1c1', '#b48ead', '#8fbcbb', '#eceff4',
]

assert_equal(ANSI, get(g:, 'terminal_ansi_colors', []), 'terminal ANSI palette')

if MODE ==# 'truecolor'
  assert_equal('#d8dee9', test.GuiColor('Terminal', 'fg'), 'Terminal GUI foreground')
  assert_equal('#2e3440', test.GuiColor('Terminal', 'bg'), 'Terminal GUI background')
else
  assert_equal('253', test.CtermColor('Terminal', 'fg'), 'Terminal cterm foreground')
  assert_equal('236', test.CtermColor('Terminal', 'bg'), 'Terminal cterm background')
endif

if MODE ==# 'truecolor' && has('terminal')
  var payload = ''
  for code in range(30, 37) + range(90, 97)
    payload ..= $"\e[{code}mX"
  endfor
  payload ..= "\e[38;5;16mA"
    .. "\e[38;5;231mB"
    .. "\e[38;5;232mC"
    .. "\e[38;5;255mD"
    .. "\e[38;2;18;52;86mE"
    .. "\e[0mF"

  # Keep the job alive while its terminal state is inspected.  A command that
  # exits immediately may turn the buffer into an ordinary finished buffer
  # before term_getansicolors() and term_scrape() run in Ex mode.
  var terminal = term_start([
    '/bin/sh', '-c', '/usr/bin/printf %s "$1"; /bin/sleep 30',
    'nord-terminal-test', payload,
  ], {
    hidden: true,
    term_kill: 'kill',
  })
  term_wait(terminal, 1000)

  assert_equal(ANSI, term_getansicolors(terminal), 'new terminal ANSI palette')
  var cells = term_scrape(terminal, 1)
  assert_true(cells->len() >= 22, 'terminal should render every color sample')

  if cells->len() >= 22
    for index in range(0, 15)
      assert_equal(ANSI[index], cells[index].fg,
        $'terminal ANSI foreground {index}')
    endfor

    assert_equal('#000000', cells[16].fg, 'xterm color 16')
    assert_equal('#ffffff', cells[17].fg, 'xterm color 231')
    assert_equal('#080808', cells[18].fg, 'xterm color 232')
    assert_equal('#eeeeee', cells[19].fg, 'xterm color 255')
    assert_equal('#123456', cells[20].fg, 'direct RGB foreground')
    assert_equal('#d8dee9', cells[21].fg, 'terminal default foreground')
    assert_equal('#2e3440', cells[21].bg, 'terminal default background')
  endif

  execute $'bwipe! {terminal}'
endif

# A reload must restore the palette for subsequently created terminal buffers.
g:terminal_ansi_colors = repeat(['#010203'], 16)
colorscheme nord
assert_equal(ANSI, g:terminal_ansi_colors, 'terminal ANSI palette after reload')

test.Finish()
