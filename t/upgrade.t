#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 7

ok 'pex init succeeds' pex init $test_repo_url

pex upgrade foobar >/dev/null 2>&1
ok 'pex upgrade foobar fails' test $? -ne 0

pex install foobar >/dev/null 2>&1
ok 'pex install foobar succeeds' test $? -eq 0

ok 'foobar-1.0 sha1 installed' grep -q $foobar10_sha1 $tmpdir/share/postgresql/pex/installed/foobar.yaml

ok_program 'pex upgrade does nothing' 0 '==> Package foobar already up to date' pex upgrade foobar

sed -i "s/foobar-1.0/foobar-1.1/;s/sha1:.*/sha1: $foobar11_sha1/" $tmpdir/home/.local/share/pex/packages/foobar.yaml

pex upgrade foobar >/dev/null 2>&1
ok 'pex upgrade runs' test $? -eq 0

ok 'foobar-1.1 sha1 installed' grep -q $foobar11_sha1 $tmpdir/share/postgresql/pex/installed/foobar.yaml

cleanup
