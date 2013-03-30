#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 1

pex init $test_repo_url

pex repotest >/dev/null 2>&1
ok 'pex repotest works' test $? -eq 0

cleanup
