vim9script

export def GuiColor(group: string, what: string): string
  return synIDattr(synIDtrans(hlID(group)), what, 'gui')
enddef

export def CtermColor(group: string, what: string): string
  return synIDattr(synIDtrans(hlID(group)), what, 'cterm')
enddef

export def HasGuiStyle(group: string, style: string): bool
  return synIDattr(synIDtrans(hlID(group)), style, 'gui') ==# '1'
enddef

export def HasCtermStyle(group: string, style: string): bool
  return synIDattr(synIDtrans(hlID(group)), style, 'cterm') ==# '1'
enddef

export def SyntaxGroup(line: number, column: number): string
  return synIDattr(synID(line, column, true), 'name')
enddef

export def AssertLink(group: string, target: string)
  var definition = hlget(group)
  assert_equal(1, definition->len(), $'{group} should exist')
  if definition->len() == 1
    assert_equal(target, definition[0]->get('linksto', ''), $'{group} link')
  endif
enddef

export def Finish()
  if !empty(v:errors)
    for error in v:errors
      echomsg error
    endfor
    cquit 1
  endif
  qall!
enddef
