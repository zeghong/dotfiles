#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
vim_bin=${VIM:-vim}

for mode in truecolor cterm
do
  for suite in core filetypes
  do
    printf 'nord %s (%s)\n' "$suite" "$mode"
    if ! NORD_TEST_MODE=$mode "$vim_bin" -N -n -i NONE -es \
      -u "$test_dir/test_$suite.vim"
    then
      NORD_TEST_MODE=$mode "$vim_bin" -N -n -i NONE -es -V1 \
        -u "$test_dir/test_$suite.vim"
      exit 1
    fi
  done
done
