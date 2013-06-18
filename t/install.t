#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 9

ok 'pex init succeeds' pex init $test_repo_url

ok_program 'no package is listed as installed' 0 '' pex list

ok_program 'pex install no argument errors' 1 'pex: "install" takes at least one argument' pex install

pex install foobar >/dev/null 2>&1
ok 'pex install foobar succeeds' test $? -eq 0

ok 'package is registered as installed' test -s $tmpdir/share/postgresql/pex/installed/foobar.yaml

ok_program 'package is listed as installed' 0 'foobar' pex list

ok 'package file was installed' test -s $tmpdir/lib/postgresql/foobar.so

pex install foobar  >/dev/null 2>&1
ok 'second installation fails' test $? -ne 0

rm $tmpdir/share/postgresql/pex/installed/foobar.yaml
pex -S install foobar >stdout.out 2>stderr.out
ok 'installation with "sudo"' grep -q SUDO stdout.out

cleanup
