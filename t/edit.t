#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 2

pex init $test_repo_url

EDITOR=echo
export EDITOR

ok_program 'pex edit works' 0 "$HOME/.local/share/pex/packages/foobar.yaml" pex edit foobar
ok_program 'pex edit works' 0 "$HOME/.local/share/pex/packages/foobar.yaml" pex edit

cleanup
