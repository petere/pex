#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 2

pex init $test_repo_url

BROWSER=echo
export BROWSER

ok_program 'pex home works' 0 'https://github.com/petere/pex' pex home

ok_program 'pex home works' 0 'http://www.example.com/' pex home foobar

cleanup
