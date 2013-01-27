#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 7

ok 'pex init succeeds' pex init $test_repo_url

ok_program 'no package is listed as installed' 0 '' pex list

pex install foobar >/dev/null 2>&1
ok 'pex install foobar succeeds' test $? -eq 0

ok 'package is registered as installed' test -s $tmpdir/share/postgresql/pex/installed/foobar.yaml

ok_program 'package is listed as installed' 0 'foobar' pex list

ok 'package file was installed' test -s $tmpdir/lib/postgresql/foobar.so

pex install foobar  >/dev/null 2>&1
ok 'second installation fails' test $? -ne 0

cleanup
