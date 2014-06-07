#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 16

ok 'pex init succeeds' pex init $test_repo_url

pex -g "$tmpdir"/nowhere/pg_config install foobar 2>/dev/null
ok 'pex install without pg_config fails cleanly' test $? -ne 0

ok_program 'no package is listed as installed' 0 '' pex list

ok_program 'pex install no argument errors' 1 'pex: "install" takes at least one argument' pex install

pex install foobar >/dev/null 2>&1
ok 'pex install foobar succeeds' test $? -eq 0

ok 'package is registered as installed' test -s $tmpdir/share/postgresql/pex/installed/foobar.yaml

ok_program 'package is listed as installed' 0 'foobar' pex list

ok 'package file was installed' test -s $tmpdir/lib/postgresql/foobar.so

pex install foobar  >/dev/null 2>&1
ok 'second installation fails' test $? -ne 0

pex install --if-not-exists foobar  >/dev/null 2>&1
ok 'second installation with --if-not-exists does not error' test $? -eq 0

pex install foobaralias1 >/dev/null 2>&1
ok 'alias installation fails when canonical name already installed' test $? -ne 0

rm -f $tmpdir/share/postgresql/pex/installed/foobar.yaml
pex install foobaralias1 >/dev/null 2>&1
ok 'alias installation succeeds' test $? -eq 0

pex install foobaralias2 >/dev/null 2>&1
ok 'duplicate alias fails' test $? -ne 0

rm -f $tmpdir/share/postgresql/pex/installed/foobar.yaml
EXTRA_ALL='; false'
export EXTRA_ALL
pex install foobar >stdout.out 2>stderr.out
ok 'make all failure detected' test $? -ne 0
unset EXTRA_ALL

rm -f $tmpdir/share/postgresql/pex/installed/foobar.yaml
EXTRA_INSTALL='; false'
export EXTRA_INSTALL
sed_in_place "s/^install:.*/install: ; false/" $tmpdir/home/.local/share/pex/packages/foobar.yaml
pex install foobar >stdout.out 2>stderr.out
ok 'make install failure detected' test $? -ne 0
unset EXTRA_INSTALL

rm -f $tmpdir/share/postgresql/pex/installed/foobar.yaml

pex -S install foobar >stdout.out 2>stderr.out
ok 'installation with "sudo"' grep -q SUDO stdout.out

cleanup
