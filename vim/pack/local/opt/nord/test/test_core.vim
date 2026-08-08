vim9script

import './helpers.vim' as test

v:errors = []

const PACKAGE_ROOT = expand('<script>:p:h:h')
execute $'set runtimepath^={fnameescape(PACKAGE_ROOT)}'

# A fixed dark theme must initialize correctly from a light predecessor.
set background=light

const MODE = getenv('NORD_TEST_MODE')
if MODE ==# 'truecolor'
  set termguicolors
elseif MODE ==# 'cterm'
  set notermguicolors
else
  assert_report($'unknown NORD_TEST_MODE: {MODE}')
endif

try
  colorscheme nord
catch
  assert_report($'colorscheme load failed: {v:exception} at {v:throwpoint}')
endtry

assert_equal('nord', get(g:, 'colors_name', ''), 'colorscheme name')
assert_equal('dark', &background, 'background mode')

if MODE ==# 'truecolor'
  assert_equal('#d8dee9', test.GuiColor('Normal', 'fg'), 'Normal GUI foreground')
  assert_equal('#2e3440', test.GuiColor('Normal', 'bg'), 'Normal GUI background')
  assert_equal('#434c5e', test.GuiColor('Visual', 'bg'), 'Visual GUI background')
  assert_equal('#434c5e', test.GuiColor('Search', 'bg'), 'Search GUI background')
  assert_equal('#88c0d0', test.GuiColor('CurSearch', 'bg'), 'CurSearch GUI background')
  assert_equal('#88c0d0', test.GuiColor('StatusLine', 'fg'), 'StatusLine GUI foreground')
  assert_equal('#616e88', test.GuiColor('Comment', 'fg'), 'Comment GUI foreground')
  assert_equal('#a3be8c', test.GuiColor('String', 'fg'), 'String GUI foreground')
  assert_equal('#b48ead', test.GuiColor('Number', 'fg'), 'Number GUI foreground')
  assert_equal('#88c0d0', test.GuiColor('Function', 'fg'), 'Function GUI foreground')
  assert_equal('#81a1c1', test.GuiColor('Keyword', 'fg'), 'Keyword GUI foreground')
  assert_equal('#a3be8c', test.GuiColor('DiffAdd', 'fg'), 'DiffAdd GUI foreground')
  assert_equal('#bf616a', test.GuiColor('DiffDelete', 'fg'), 'DiffDelete GUI foreground')
  assert_equal('#ebcb8b', test.GuiColor('DiffText', 'fg'), 'DiffText GUI foreground')
  assert_equal('#bf616a', synIDattr(hlID('SpellBad'), 'sp', 'gui'), 'SpellBad GUI special color')
  assert_true(test.HasGuiStyle('CursorLineNr', 'bold'), 'CursorLineNr should be bold')
  assert_true(test.HasGuiStyle('DiffText', 'bold'), 'DiffText should be bold')
  assert_true(test.HasGuiStyle('SpellBad', 'undercurl'), 'SpellBad should use GUI undercurl')
else
  assert_equal('253', test.CtermColor('Normal', 'fg'), 'Normal cterm foreground')
  assert_equal('236', test.CtermColor('Normal', 'bg'), 'Normal cterm background')
  assert_equal('238', test.CtermColor('Visual', 'bg'), 'Visual cterm background')
  assert_equal('238', test.CtermColor('Search', 'bg'), 'Search cterm background')
  assert_equal('116', test.CtermColor('CurSearch', 'bg'), 'CurSearch cterm background')
  assert_equal('60', test.CtermColor('Comment', 'fg'), 'Comment cterm foreground')
  assert_equal('150', test.CtermColor('String', 'fg'), 'String cterm foreground')
  assert_equal('139', test.CtermColor('Number', 'fg'), 'Number cterm foreground')
  assert_equal('116', test.CtermColor('Function', 'fg'), 'Function cterm foreground')
  assert_equal('110', test.CtermColor('Keyword', 'fg'), 'Keyword cterm foreground')
  assert_equal('150', test.CtermColor('DiffAdd', 'fg'), 'DiffAdd cterm foreground')
  assert_equal('131', test.CtermColor('DiffDelete', 'fg'), 'DiffDelete cterm foreground')
  assert_true(test.HasCtermStyle('SpellBad', 'underline'), 'SpellBad should fall back to cterm underline')
endif

test.AssertLink('lCursor', 'Cursor')
test.AssertLink('NormalNC', 'Normal')
test.AssertLink('VertSplit', 'WinSeparator')
test.AssertLink('StatusLineTerm', 'StatusLine')
test.AssertLink('Whitespace', 'NonText')
test.AssertLink('Character', 'String')
test.AssertLink('Float', 'Number')
test.AssertLink('Keyword', 'Statement')
test.AssertLink('Include', 'PreProc')
test.AssertLink('StorageClass', 'Type')

# Reloading must be idempotent and must restore the scheme after another theme.
try
  colorscheme nord
  colorscheme default
  colorscheme nord
catch
  assert_report($'colorscheme reload failed: {v:exception} at {v:throwpoint}')
endtry

assert_equal('nord', get(g:, 'colors_name', ''), 'colorscheme name after reload')
assert_equal('dark', &background, 'background after reload')
assert_equal('#2e3440', test.GuiColor('Normal', 'bg'), 'Normal GUI background after reload')

test.Finish()
