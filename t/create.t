#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 4

pex init $test_repo_url

EDITOR=echo
export EDITOR

echo barbar >$tmpdir/barbar-1.0.tar.gz

pex create -n barbar file://$tmpdir/barbar-1.0.tar.gz >stdout.out 2>/dev/null

ok 'pex create runs' grep -q "^$HOME/.local/share/pex/packages/barbar.yaml\$" stdout.out

ok_program 'package file was created' 0 "homepage: FIXME
url: file://$tmpdir/barbar-1.0.tar.gz
sha1: 5619cedcdc1d07a16eb2cb8f132ecdd08e1d699a" cat $HOME/.local/share/pex/packages/barbar.yaml

ok 'archive was downloaded' test -f $HOME/.cache/pex/barbar/download/barbar.tar.gz

ok_program 'pex create without arguments errors' 1 'pex: "create" takes exactly one nonoption argument' pex create

cleanup
