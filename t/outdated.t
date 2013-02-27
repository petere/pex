#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 3

pex init $test_repo_url

ok_program 'pex outdated initially empty' 0 '' pex outdated

pex install foobar 2>/dev/null

sed_in_place "s/foobar-1.0/foobar-1.1/;s/sha1:.*/sha1: $foobar11_sha1/" $tmpdir/home/.local/share/pex/packages/foobar.yaml

ok_program 'pex outdated shows something' 0 'foobar' pex outdated

ok_program 'pex outdated with arguments errors' 1 'pex: "outdated" takes no arguments' pex outdated foo bar

cleanup
