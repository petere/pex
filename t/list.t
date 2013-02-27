#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 1

pex init $test_repo_url

ok_program 'pex list with arguments errors' 1 'pex: "list" takes no arguments' pex list foo bar

# more tests are in install.t

cleanup
