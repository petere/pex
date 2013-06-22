#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 3

pex init $test_repo_url

EDITOR=echo
export EDITOR

ok_program 'pex edit works' 0 "$HOME/.local/share/pex/packages/foobar.yaml" pex edit foobar
ok_program 'pex edit works' 0 "$HOME/.local/share/pex/packages/foobar.yaml $HOME/.local/share/pex/packages/zoobar.yaml" pex edit
ok_program 'pex edit with nonexistent package fails' 1 'pex: package "nonexistent" does not exist' pex edit nonexistent

cleanup
