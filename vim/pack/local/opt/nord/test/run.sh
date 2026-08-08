#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
vim_bin=${VIM:-vim}

for mode in truecolor cterm
do
  printf 'nord core (%s)\n' "$mode"
  NORD_TEST_MODE=$mode "$vim_bin" -N -n -i NONE -es -V1 \
    -u "$test_dir/test_core.vim"
done
