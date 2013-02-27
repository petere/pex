#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 3

pex init $test_repo_url

BROWSER=echo
export BROWSER

ok_program 'pex home without argument works' 0 'https://github.com/petere/pex' pex home

ok_program 'pex home with one argument works' 0 'http://www.example.com/' pex home foobar

ok_program 'pex home with multiple arguments works' 0 'http://www.example.com/ http://www.example.com/' pex home foobar foobar

cleanup
