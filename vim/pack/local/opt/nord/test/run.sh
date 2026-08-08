#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
vim_bin=${VIM:-vim}

for mode in truecolor cterm
do
  for suite in core filetypes lsp terminal
  do
    if [ "$suite" = lsp ]
    then
      orders='theme-first plugin-first'
    else
      orders='default'
    fi

    for order in $orders
    do
      printf 'nord %s (%s, %s)\n' "$suite" "$mode" "$order"
      if ! NORD_TEST_MODE=$mode NORD_LSP_ORDER=$order \
        "$vim_bin" -N -n -i NONE -es -u "$test_dir/test_$suite.vim"
      then
        NORD_TEST_MODE=$mode NORD_LSP_ORDER=$order \
          "$vim_bin" -N -n -i NONE -es -V1 -u "$test_dir/test_$suite.vim"
        exit 1
      fi
    done
  done
done
