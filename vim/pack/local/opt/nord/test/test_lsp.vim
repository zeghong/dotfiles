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

# These are the defaults installed by yegappan/lsp.  Reproducing them here
# keeps the colorscheme test isolated from an optional, ignored dependency.
def InstallPluginDefaults()
  hlset([
    {name: 'LspPopup', default: true, linksto: 'Pmenu'},
    {name: 'LspPopupBorder', default: true, linksto: 'Pmenu'},
    {name: 'LspTextRef', default: true, linksto: 'Search'},
    {name: 'LspReadRef', default: true, linksto: 'DiffChange'},
    {name: 'LspWriteRef', default: true, linksto: 'DiffDelete'},
    {name: 'LspDiagLine', default: true, linksto: 'NONE'},
    {name: 'LspDiagInlineError', default: true, linksto: 'SpellBad'},
    {name: 'LspDiagVirtualTextError', default: true, linksto: 'SpellBad'},
    {name: 'LspInlayHintsType', default: true, linksto: 'Label'},
    {name: 'LspSigActiveParameter', default: true, linksto: 'LineNr'},
    {name: 'LspSemanticFunction', default: true, linksto: 'Function'},
    {name: 'LspSemanticMethod', default: true, linksto: 'Function'},
    {name: 'LspSemanticType', default: true, linksto: 'Type'}
  ])
  highlight LspBold gui=bold cterm=bold
  highlight LspItalic gui=italic cterm=italic
  highlight LspStrikeThrough gui=strikethrough cterm=strikethrough
enddef

const ORDER = getenv('NORD_LSP_ORDER')
if ORDER ==# 'theme-first'
  colorscheme nord
  InstallPluginDefaults()
elseif ORDER ==# 'plugin-first'
  InstallPluginDefaults()
  colorscheme nord
else
  assert_report($'unknown NORD_LSP_ORDER: {ORDER}')
endif

def AssertForeground(group: string, gui: string, cterm: string)
  if MODE ==# 'truecolor'
    assert_equal(gui, test.GuiColor(group, 'fg'), $'{group} GUI foreground')
  else
    assert_equal(cterm, test.CtermColor(group, 'fg'), $'{group} cterm foreground')
  endif
enddef

def AssertBackground(group: string, gui: string, cterm: string)
  if MODE ==# 'truecolor'
    assert_equal(gui, test.GuiColor(group, 'bg'), $'{group} GUI background')
  else
    assert_equal(cterm, test.CtermColor(group, 'bg'), $'{group} cterm background')
  endif
enddef

AssertForeground('LspDiagSignErrorText', '#bf616a', '131')
AssertForeground('LspDiagSignWarningText', '#ebcb8b', '222')
AssertForeground('LspDiagSignInfoText', '#88c0d0', '116')
AssertForeground('LspDiagSignHintText', '#5e81ac', '67')
AssertBackground('LspDiagVirtualTextError', '#3b4252', '237')
AssertBackground('LspTextRef', '#434c5e', '238')
AssertBackground('LspReadRef', '#434c5e', '238')
AssertBackground('LspWriteRef', '#434c5e', '238')
AssertForeground('LspPopupBorder', '#4c566a', '240')
AssertForeground('LspInlayHintsType', '#81a1c1', '110')
AssertForeground('LspInlayHintsParam', '#4c566a', '240')
AssertForeground('LspSigActiveParameter', '#88c0d0', '116')
AssertForeground('LspSemanticDecorator', '#d08770', '173')
AssertForeground('qfError', '#bf616a', '131')
AssertBackground('QuickFixLine', '#434c5e', '238')
assert_equal('', test.GuiColor('qfError', 'bg'), 'qfError should not use a GUI background')
assert_equal('', test.GuiColor('QuickFixLine', 'fg'),
  'QuickFixLine should preserve syntax foregrounds')
assert_false(test.HasGuiStyle('QuickFixLine', 'bold'),
  'QuickFixLine should not force bold text')

if MODE ==# 'truecolor'
  assert_true(test.HasGuiStyle('LspDiagInlineError', 'undercurl'),
    'inline diagnostics should use GUI undercurl')
  assert_equal('#bf616a', synIDattr(hlID('LspDiagInlineError'), 'sp', 'gui'),
    'inline diagnostic GUI special color')
  assert_true(test.HasGuiStyle('LspInlayHintsType', 'italic'),
    'type inlay hint should be italic')
  assert_true(test.HasGuiStyle('LspSigActiveParameter', 'underline'),
    'active signature parameter should be underlined')
  assert_true(test.HasGuiStyle('LspBold', 'bold'),
    'LSP Markdown bold should survive load order')
  assert_true(test.HasGuiStyle('LspItalic', 'italic'),
    'LSP Markdown italic should survive load order')
  assert_true(test.HasGuiStyle('LspStrikeThrough', 'strikethrough'),
    'LSP Markdown strikethrough should survive load order')
else
  assert_true(test.HasCtermStyle('LspDiagInlineError', 'underline'),
    'inline diagnostics should fall back to cterm underline')
  assert_true(test.HasCtermStyle('LspBold', 'bold'),
    'LSP Markdown bold should survive cterm load order')
  assert_true(test.HasCtermStyle('LspItalic', 'italic'),
    'LSP Markdown italic should survive cterm load order')
  assert_true(test.HasCtermStyle('LspStrikeThrough', 'strikethrough'),
    'LSP Markdown strikethrough should survive cterm load order')
endif

test.AssertLink('LspPopup', 'Pmenu')
test.AssertLink('LspSymbolName', 'Search')
test.AssertLink('LspSymbolRange', 'Visual')
test.AssertLink('LspSemanticType', 'Type')
test.AssertLink('LspSemanticVariable', 'Identifier')
test.AssertLink('LspSemanticString', 'String')

# Function and method tokens must remain explicit, empty groups.  Linking them
# to Function would override both plain Go calls and the distinct builtin color.
for group in ['LspSemanticFunction', 'LspSemanticMethod']
  var definition = hlget(group)
  assert_equal(1, definition->len(), $'{group} should exist')
  if definition->len() == 1
    assert_equal('', definition[0]->get('linksto', ''), $'{group} must not link')
  endif
  assert_equal('', test.GuiColor(group, 'fg'), $'{group} GUI foreground should be neutral')
  assert_equal('', test.GuiColor(group, 'bg'), $'{group} GUI background should be neutral')
endfor

# Reloading after plugin defaults exist must restore every theme override.
colorscheme default
colorscheme nord
AssertBackground('LspWriteRef', '#434c5e', '238')
AssertForeground('LspDiagSignErrorText', '#bf616a', '131')
assert_equal('', hlget('LspSemanticFunction')[0]->get('linksto', ''),
  'semantic function should remain neutral after reload')
assert_true(test.HasGuiStyle('LspBold', 'bold'),
  'LSP Markdown bold should survive colorscheme reload')
assert_true(test.HasGuiStyle('LspItalic', 'italic'),
  'LSP Markdown italic should survive colorscheme reload')
assert_true(test.HasGuiStyle('LspStrikeThrough', 'strikethrough'),
  'LSP Markdown strikethrough should survive colorscheme reload')

test.Finish()
