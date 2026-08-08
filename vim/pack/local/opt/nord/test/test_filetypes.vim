vim9script

import './helpers.vim' as test

v:errors = []

const TEST_ROOT = expand('<script>:p:h')
const PACKAGE_ROOT = TEST_ROOT .. '/..'
execute $'set runtimepath^={fnameescape(PACKAGE_ROOT)}'

const MODE = getenv('NORD_TEST_MODE')
if MODE ==# 'truecolor'
  set termguicolors
elseif MODE ==# 'cterm'
  set notermguicolors
else
  assert_report($'unknown NORD_TEST_MODE: {MODE}')
endif

syntax enable
colorscheme nord

assert_false(exists('g:go_highlight_functions'), 'theme must not enable Go function syntax')
assert_false(exists('g:go_highlight_function_calls'), 'theme must not enable Go call syntax')

def OpenFixture(name: string, filetype: string)
  enew!
  setlocal buftype=nofile bufhidden=wipe noswapfile
  setline(1, readfile(TEST_ROOT .. '/fixtures/' .. name))
  execute $'setlocal syntax={filetype}'
  syntax sync fromstart
enddef

def AssertForeground(group: string, gui: string, cterm: string)
  if MODE ==# 'truecolor'
    assert_equal(gui, test.GuiColor(group, 'fg'), $'{group} GUI foreground')
  else
    assert_equal(cterm, test.CtermColor(group, 'fg'), $'{group} cterm foreground')
  endif
enddef

# Exact mappings are stable; representative tokens prove Vim's runtime syntax
# reaches those mappings for real files.
AssertForeground('vimAugroupName', '#8fbcbb', '109')
AssertForeground('goBuiltins', '#8fbcbb', '109')
AssertForeground('jsonKeyword', '#81a1c1', '110')
AssertForeground('hclAttributeName', '#81a1c1', '110')
AssertForeground('markdownH1', '#88c0d0', '116')
AssertForeground('gitcommitUntrackedFile', '#bf616a', '131')
AssertForeground('gitcommitSelectedFile', '#a3be8c', '150')
AssertForeground('gitcommitDiscardedFile', '#bf616a', '131')
AssertForeground('gitcommitUnmergedFile', '#ebcb8b', '222')
AssertForeground('Added', '#a3be8c', '150')

test.AssertLink('goFunctionCall', 'Function')
test.AssertLink('goFunction', 'Function')
test.AssertLink('jsonNull', 'Boolean')
test.AssertLink('shCmdSubRegion', 'Delimiter')
test.AssertLink('shDerefSimple', 'Identifier')
test.AssertLink('gitcommitSummary', 'Statement')
test.AssertLink('diffAdded', 'Added')

OpenFixture('sample.vim', 'vim')
assert_equal('vimAugroupName', test.SyntaxGroup(3, 9), 'Vim augroup token')
assert_equal('vimMapLeader', test.SyntaxGroup(12, 10), 'Vim map leader token')

OpenFixture('sample.go', 'go')
assert_equal('', test.SyntaxGroup(3, 6), 'Go declaration name stays plain by default')
assert_equal('goBuiltins', test.SyntaxGroup(4, 10), 'Go builtin token')
assert_equal('', test.SyntaxGroup(8, 2), 'Go function call stays plain by default')

OpenFixture('sample.json', 'json')
assert_equal('jsonKeyword', test.SyntaxGroup(2, 4), 'JSON key token')
assert_equal('jsonNull', test.SyntaxGroup(5, 15), 'JSON null token')

OpenFixture('sample.tf', 'terraform')
assert_equal('hclAttributeName', test.SyntaxGroup(2, 3), 'Terraform attribute token')

OpenFixture('sample.sh', 'sh')
assert_equal('shDerefSimple', test.SyntaxGroup(3, 26), 'Shell dereference token')
assert_equal('shCmdSubRegion', test.SyntaxGroup(3, 18), 'Shell substitution delimiter')

OpenFixture('sample.md', 'markdown')
assert_equal('markdownH1', test.SyntaxGroup(1, 3), 'Markdown heading token')
assert_equal('markdownCode', test.SyntaxGroup(3, 48), 'Markdown code token')

OpenFixture('COMMIT_EDITMSG', 'gitcommit')
assert_equal('gitcommitSummary', test.SyntaxGroup(1, 1), 'Git summary token')
assert_equal('gitcommitSelectedFile', test.SyntaxGroup(5, 15), 'Git selected token')
assert_equal('gitcommitDiscardedFile', test.SyntaxGroup(8, 15), 'Git discarded token')
assert_equal('gitcommitUnmergedFile', test.SyntaxGroup(11, 20), 'Git unmerged token')
assert_equal('gitcommitUntrackedFile', test.SyntaxGroup(15, 3), 'Git untracked token')

OpenFixture('sample.diff', 'diff')
assert_equal('diffRemoved', test.SyntaxGroup(5, 2), 'Diff removed token')
assert_equal('diffAdded', test.SyntaxGroup(6, 2), 'Diff added token')

# A reload while syntax items already exist must restore language mappings.
try
  colorscheme default
  colorscheme nord
catch
  assert_report($'filetype mapping reload failed: {v:exception} at {v:throwpoint}')
endtry
test.AssertLink('goFunctionCall', 'Function')
test.AssertLink('shCmdSubRegion', 'Delimiter')
AssertForeground('jsonKeyword', '#81a1c1', '110')
AssertForeground('gitcommitUntrackedFile', '#bf616a', '131')

test.Finish()
