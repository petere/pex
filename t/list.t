#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 2

pex init $test_repo_url

ok_program 'pex list with arguments errors' 1 'pex: "list" takes no arguments' pex list foo bar

# more tests are in install.t

pex -g "$tmpdir"/nowhere/pg_config list 2>/dev/null
ok 'pex list without pg_config fails cleanly' test $? -ne 0

cleanup
