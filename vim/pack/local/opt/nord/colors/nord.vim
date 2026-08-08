vim9script

# An unofficial, independent Vim 9 implementation of the Nord color palette.
# Palette source: https://github.com/nordtheme/nord

set background=dark
highlight clear
g:colors_name = 'nord'

const GUI: dict<string> = {
  nord0: '#2e3440',
  nord1: '#3b4252',
  nord2: '#434c5e',
  nord3: '#4c566a',
  nord4: '#d8dee9',
  nord5: '#e5e9f0',
  nord6: '#eceff4',
  nord7: '#8fbcbb',
  nord8: '#88c0d0',
  nord9: '#81a1c1',
  nord10: '#5e81ac',
  nord11: '#bf616a',
  nord12: '#d08770',
  nord13: '#ebcb8b',
  nord14: '#a3be8c',
  nord15: '#b48ead',

  # Brightened nord3 used by nordtheme/vim for readable comments.
  comment: '#616e88',
}

# Fixed xterm-256 approximations preserve the palette's visual hierarchy when
# 24-bit color is unavailable. They intentionally do not depend on ANSI 0-15.
const CTERM: dict<number> = {
  nord0: 236,
  nord1: 237,
  nord2: 238,
  nord3: 240,
  nord4: 253,
  nord5: 254,
  nord6: 255,
  nord7: 109,
  nord8: 116,
  nord9: 110,
  nord10: 67,
  nord11: 131,
  nord12: 173,
  nord13: 222,
  nord14: 150,
  nord15: 139,

  comment: 60,
}

def Highlight(
    group: string,
    foreground: string = '',
    background: string = '',
    gui_style: string = 'NONE',
    special: string = '',
    cterm_style: string = '')
  var command = $'highlight {group}'

  if foreground != ''
    command ..= $' guifg={GUI[foreground]} ctermfg={CTERM[foreground]}'
  else
    command ..= ' guifg=NONE ctermfg=NONE'
  endif

  if background != ''
    command ..= $' guibg={GUI[background]} ctermbg={CTERM[background]}'
  else
    command ..= ' guibg=NONE ctermbg=NONE'
  endif

  command ..= $' gui={gui_style}'
  command ..= $' cterm={cterm_style == '' ? gui_style : cterm_style}'
  command ..= $' guisp={special == '' ? 'NONE' : GUI[special]}'
  execute command
enddef

def Link(group: string, target: string)
  execute $'highlight! link {group} {target}'
enddef

# Editor canvas and cursor.
Highlight('Normal', 'nord4', 'nord0')
Link('NormalNC', 'Normal')
Highlight('Cursor', 'nord0', 'nord4')
Link('lCursor', 'Cursor')
Link('CursorIM', 'Cursor')
Highlight('CursorLine', '', 'nord1')
Link('CursorColumn', 'CursorLine')
Highlight('ColorColumn', '', 'nord1')

# Gutter, folds, and structural separators.
Highlight('LineNr', 'nord3', 'nord0')
Link('LineNrAbove', 'LineNr')
Link('LineNrBelow', 'LineNr')
Highlight('CursorLineNr', 'nord8', '', 'bold')
Highlight('SignColumn', 'nord3', 'nord0')
Highlight('FoldColumn', 'nord3', 'nord0')
Highlight('Folded', 'nord4', 'nord1')
Highlight('WinSeparator', 'nord3', 'nord0')
Link('VertSplit', 'WinSeparator')

# Selection, search, and matching.
Highlight('Visual', '', 'nord2')
Link('VisualNOS', 'Visual')
Highlight('Search', 'nord4', 'nord2')
Highlight('CurSearch', 'nord1', 'nord8', 'bold')
Link('IncSearch', 'CurSearch')
Link('Substitute', 'CurSearch')
Highlight('MatchParen', 'nord8', 'nord3', 'bold')

# Completion and command-line menus.
Highlight('Pmenu', 'nord4', 'nord1')
Highlight('PmenuSel', 'nord8', 'nord2')
Highlight('PmenuSbar', '', 'nord1')
Highlight('PmenuThumb', '', 'nord3')
Highlight('PmenuKind', 'nord7', 'nord1')
Highlight('PmenuKindSel', 'nord7', 'nord2')
Highlight('PmenuExtra', 'nord3', 'nord1')
Highlight('PmenuExtraSel', 'nord3', 'nord2')
Highlight('WildMenu', 'nord8', 'nord2')

# Status lines and tabs.
Highlight('StatusLine', 'nord8', 'nord3')
Highlight('StatusLineNC', 'nord4', 'nord1')
Link('StatusLineTerm', 'StatusLine')
Link('StatusLineTermNC', 'StatusLineNC')
Highlight('TabLine', 'nord4', 'nord1')
Highlight('TabLineSel', 'nord8', 'nord3')
Highlight('TabLineFill', 'nord3', 'nord0')

# Diff uses one quiet surface; semantic foregrounds identify the change type.
Highlight('DiffAdd', 'nord14', 'nord1')
Highlight('DiffDelete', 'nord11', 'nord1')
Highlight('DiffChange', 'nord13', 'nord1')
Highlight('DiffText', 'nord13', 'nord2', 'bold')

# Messages and transient editor states.
Highlight('ErrorMsg', 'nord4', 'nord11', 'bold')
Highlight('WarningMsg', 'nord13', 'nord0', 'bold')
Highlight('MoreMsg', 'nord14', 'nord0')
Highlight('Question', 'nord8', 'nord0')
Highlight('ModeMsg', 'nord8', 'nord0', 'bold')
Highlight('Title', 'nord8', 'nord0', 'bold')
Highlight('Directory', 'nord8', 'nord0')
# Keep syntax colors visible while marking the selected quickfix entry.
Highlight('QuickFixLine', '', 'nord2')

# Low-attention and concealed editor content.
Highlight('NonText', 'nord3', 'nord0')
Link('Whitespace', 'NonText')
Link('SpecialKey', 'NonText')
Highlight('EndOfBuffer', 'nord0', 'nord0')
Highlight('Conceal', 'nord3', 'nord0')

# Vim's standard syntax groups form the semantic base for filetype-specific
# links added by later integration layers.
Highlight('Comment', 'comment')

Highlight('Constant', 'nord4')
Highlight('String', 'nord14')
Link('Character', 'String')
Highlight('Number', 'nord15')
Link('Float', 'Number')
Highlight('Boolean', 'nord9')

Highlight('Identifier', 'nord4')
Highlight('Function', 'nord8')

Highlight('Statement', 'nord9')
Link('Conditional', 'Statement')
Link('Repeat', 'Statement')
Link('Label', 'Statement')
Link('Operator', 'Statement')
Link('Keyword', 'Statement')
Link('Exception', 'Statement')

Highlight('PreProc', 'nord9')
Link('Include', 'PreProc')
Link('Define', 'PreProc')
Link('Macro', 'PreProc')
Link('PreCondit', 'PreProc')

Highlight('Type', 'nord9')
Link('StorageClass', 'Type')
Link('Structure', 'Type')
Link('Typedef', 'Type')

Highlight('Special', 'nord4')
Highlight('SpecialChar', 'nord13')
Link('Tag', 'Special')
Highlight('Delimiter', 'nord6')
Link('SpecialComment', 'SpecialChar')
Highlight('Debug', 'nord12')

Highlight('Underlined', 'nord8', '', 'underline')
Highlight('Ignore', 'nord3')
Highlight('Error', 'nord4', 'nord11', 'bold')
Highlight('Todo', 'nord13', 'nord1', 'bold')

# Spell checking augments syntax colors instead of replacing them.
Highlight('SpellBad', '', '', 'undercurl', 'nord11', 'underline')
Highlight('SpellCap', '', '', 'undercurl', 'nord13', 'underline')
Highlight('SpellLocal', '', '', 'undercurl', 'nord8', 'underline')
Highlight('SpellRare', '', '', 'undercurl', 'nord15', 'underline')

# Vim and Vim9 script.
Highlight('vimAugroupName', 'nord7')
Highlight('vimMapRhs', 'nord7')
Highlight('vimNotation', 'nord7')
Link('vimMapLeader', 'vimNotation')
Link('vimFunc', 'Function')
Link('vimFunction', 'Function')
Link('vimUserFunc', 'Function')
Link('vim9Func', 'Function')
Link('vim9UserFunc', 'Function')
Link('vim9MethodName', 'Function')

# Go keeps declarations and calls consistent while builtins remain structural.
Link('goFunction', 'Function')
Link('goFunctionCall', 'Function')
Highlight('goBuiltins', 'nord7')

# JSON keys share nord9 with fixed literals to keep documents cohesive.
Highlight('jsonKeyword', 'nord9')
Link('jsonNull', 'Boolean')
Link('jsonQuote', 'Ignore')
Link('jsonNoise', 'Ignore')
Link('jsonBraces', 'Delimiter')
# Configuration labels share the same structural color across JSON and HCL.
Highlight('hclAttributeName', 'nord9')

# Shell substitutions and dereferences are structural rather than executable.
Link('shCmdParenRegion', 'Delimiter')
Link('shCmdSubRegion', 'Delimiter')
Link('shDerefSimple', 'Identifier')
Link('shDerefVar', 'Identifier')

# Markdown favors restrained document structure over extra syntax colors.
Highlight('markdownH1', 'nord8', '', 'bold')
Highlight('markdownH2', 'nord8', '', 'bold')
Highlight('markdownH3', 'nord8', '', 'bold')
Highlight('markdownH4', 'nord8', '', 'bold')
Highlight('markdownH5', 'nord8', '', 'bold')
Highlight('markdownH6', 'nord8', '', 'bold')
Highlight('markdownLinkText', 'nord8')
Highlight('markdownBlockquote', 'nord7')
Highlight('markdownCode', 'nord7')
Highlight('markdownCodeBlock', 'nord7')
Highlight('markdownCodeDelimiter', 'nord7')
Highlight('markdownFootnote', 'nord7')
Highlight('markdownFootnoteDefinition', 'nord7')
Highlight('markdownIdDeclaration', 'nord7')
Highlight('markdownId', 'nord7')
Highlight('markdownListMarker', 'nord7')
Highlight('markdownUrl', 'nord4')
Highlight('markdownBold', '', '', 'bold')
Highlight('markdownItalic', '', '', 'italic')
Highlight('markdownBoldItalic', '', '', 'bold,italic')

# Git commit states use Aurora colors as status, not decoration.
Link('gitcommitSummary', 'Statement')
Highlight('gitcommitBranch', 'nord8', '', 'bold')
Highlight('gitcommitSelectedType', 'nord14')
Highlight('gitcommitSelectedFile', 'nord14')
Highlight('gitcommitSelectedArrow', 'nord14')
Highlight('gitcommitDiscardedType', 'nord11')
Highlight('gitcommitDiscardedFile', 'nord11')
Highlight('gitcommitDiscardedArrow', 'nord11')
Highlight('gitcommitUnmergedType', 'nord13')
Highlight('gitcommitUnmergedFile', 'nord13')
Highlight('gitcommitUnmergedArrow', 'nord13')
Highlight('gitcommitUntrackedFile', 'nord11')
Link('gitcommitHash', 'Identifier')

# Vim's diff syntax uses these semantic groups rather than the Diff* UI groups.
Highlight('Added', 'nord14')
Highlight('Removed', 'nord11')
Highlight('Changed', 'nord13')
Link('diffAdded', 'Added')
Link('diffRemoved', 'Removed')
Link('diffChanged', 'Changed')

# yegappan/lsp diagnostics keep syntax colors intact and add severity through
# signs, undercurls, or virtual text.  No diagnostic paints the whole line.
Highlight('LspDiagLine')
Highlight('LspDiagSignErrorText', 'nord11')
Highlight('LspDiagSignWarningText', 'nord13')
Highlight('LspDiagSignInfoText', 'nord8')
Highlight('LspDiagSignHintText', 'nord10')
Highlight('LspDiagInlineError', '', '', 'undercurl', 'nord11', 'underline')
Highlight('LspDiagInlineWarning', '', '', 'undercurl', 'nord13', 'underline')
Highlight('LspDiagInlineInfo', '', '', 'undercurl', 'nord8', 'underline')
Highlight('LspDiagInlineHint', '', '', 'undercurl', 'nord10', 'underline')
Highlight('LspDiagVirtualTextError', 'nord11', 'nord1')
Highlight('LspDiagVirtualTextWarning', 'nord13', 'nord1')
Highlight('LspDiagVirtualTextInfo', 'nord8', 'nord1')
Highlight('LspDiagVirtualTextHint', 'nord10', 'nord1')

# Vim's quickfix syntax recognizes the literal error severity in location
# lists.  Use a foreground only so selection and severity can compose.
Highlight('qfError', 'nord11')

# Popups and document references use quiet surfaces instead of borrowing
# search, diff, and error semantics from the plugin defaults.
Link('LspPopup', 'Pmenu')
Highlight('LspPopupBorder', 'nord3', 'nord1')
Highlight('LspTextRef', '', 'nord2')
Highlight('LspReadRef', '', 'nord2')
Highlight('LspWriteRef', '', 'nord2')
Highlight('LspInlayHintsType', 'nord9', '', 'italic')
Highlight('LspInlayHintsParam', 'nord3', '', 'italic')
Highlight('LspSigActiveParameter', 'nord8', '', 'underline')
Link('LspSymbolName', 'Search')
Link('LspSymbolRange', 'Visual')

# Preserve Markdown emphasis in hover and signature content across theme
# reloads; yegappan otherwise defines these styles only when its parser loads.
Highlight('LspBold', '', '', 'bold')
Highlight('LspItalic', '', '', 'italic')
Highlight('LspStrikeThrough', '', '', 'strikethrough')

# Semantic tokens reuse the core vocabulary.  Function and method tokens are
# deliberately neutral: yegappan currently discards token modifiers, so it
# cannot distinguish declarations, calls, and default-library functions.  Its
# combined text properties therefore leave the underlying syntax color visible.
Link('LspSemanticNamespace', 'Type')
Link('LspSemanticType', 'Type')
Link('LspSemanticClass', 'Type')
Link('LspSemanticEnum', 'Type')
Link('LspSemanticInterface', 'Type')
Link('LspSemanticStruct', 'Type')
Link('LspSemanticTypeParameter', 'Type')
Link('LspSemanticParameter', 'Identifier')
Link('LspSemanticVariable', 'Identifier')
Link('LspSemanticProperty', 'Identifier')
Link('LspSemanticEnumMember', 'Constant')
Link('LspSemanticEvent', 'Identifier')
# A special color without an underline is visually inert, but marks each group
# as defined so a later `highlight default` cannot relink it to Function.
Highlight('LspSemanticFunction', '', '', 'NONE', 'nord0')
Highlight('LspSemanticMethod', '', '', 'NONE', 'nord0')
Link('LspSemanticMacro', 'Macro')
Link('LspSemanticKeyword', 'Keyword')
Link('LspSemanticModifier', 'Type')
Link('LspSemanticComment', 'Comment')
Link('LspSemanticString', 'String')
Link('LspSemanticNumber', 'Number')
Link('LspSemanticRegexp', 'String')
Link('LspSemanticOperator', 'Operator')
Highlight('LspSemanticDecorator', 'nord12')

# Vim's built-in terminal uses the editor canvas for its default colors.
Highlight('Terminal', 'nord4', 'nord0')

# ANSI 0-15 mirrors Ghostty's built-in Nord theme so the outer shell and a
# Vim :terminal render indexed programs consistently.  Slot 8 is Ghostty's
# brighter black; ANSI 16-255 and direct RGB remain Vim/xterm responsibilities.
const TERMINAL_ANSI: list<string> = [
  '#3b4252', # 0  black
  '#bf616a', # 1  red
  '#a3be8c', # 2  green
  '#ebcb8b', # 3  yellow
  '#81a1c1', # 4  blue
  '#b48ead', # 5  magenta
  '#88c0d0', # 6  cyan
  '#e5e9f0', # 7  white
  '#596377', # 8  bright black (Ghostty Nord)
  '#bf616a', # 9  bright red
  '#a3be8c', # 10 bright green
  '#ebcb8b', # 11 bright yellow
  '#81a1c1', # 12 bright blue
  '#b48ead', # 13 bright magenta
  '#8fbcbb', # 14 bright cyan
  '#eceff4', # 15 bright white
]
g:terminal_ansi_colors = TERMINAL_ANSI->copy()
