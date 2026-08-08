vim9script

import './helpers.vim' as test

v:errors = []

const PACKAGE_ROOT = expand('<script>:p:h:h')
const VIM_ROOT = PACKAGE_ROOT->fnamemodify(':h:h:h:h')
execute $'set runtimepath^={fnameescape(VIM_ROOT)}'
execute $'set packpath^={fnameescape(VIM_ROOT)}'

# Prove that the real vimrc enables the preferred rendering path and loads the
# optional package instead of duplicating its startup commands in this test.
set notermguicolors
execute $'source {fnameescape(VIM_ROOT .. "/vimrc")}'

assert_equal('nord', get(g:, 'colors_name', ''), 'startup colorscheme')
assert_equal(has('termguicolors') == 1, &termguicolors,
  'startup truecolor support')
assert_equal('#d8dee9', test.GuiColor('Normal', 'fg'), 'startup Normal foreground')
assert_equal('#2e3440', test.GuiColor('Normal', 'bg'), 'startup Normal background')
assert_equal(16, get(g:, 'terminal_ansi_colors', [])->len(),
  'startup terminal ANSI palette')

test.Finish()
