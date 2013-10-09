#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

if ! which debuild >/dev/null 2>&1; then
	skip_all 'debuild not installed'
	cleanup
	exit
fi

plan 2

pex init $test_repo_url

pex rpmbuild foobar >stdout.out 2>stderr.out
ok 'debuild works' test $? -eq 0
ok 'deb was created' test -s $HOME/TODO

cleanup
