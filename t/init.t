#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 5

pex update >/dev/null 2>&1
ok 'pex update before init fails' test $? -ne 0

ok_program 'pex init with too many arguments fails' 1 'pex: "init" takes zero or one arguments' pex init blah blah

ok 'pex init succeeds' pex init $test_repo_url

ok_program 'pex --cache output' 0 "$tmpdir/home/.cache/pex" pex --cache

ok_program 'pex --repository output' 0 "$tmpdir/home/.local/share/pex/packages" pex --repository

cleanup
