#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

if ! which rpmbuild >/dev/null 2>&1; then
	skip_all 'rpmbuild not installed'
	cleanup
	exit
fi

plan 2

pex init $test_repo_url

pex rpmbuild foobar -ba --nodeps >stdout.out 2>stderr.out
ok 'rpmbuild works' test $? -eq 0
ok 'rpm was created' test -s $HOME/rpmbuild/SRPMS/postgresql-foobar-1.0-1.src.rpm

cleanup
