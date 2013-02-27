#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 5

pex init $test_repo_url

ok_program 'pex search foo returns foobar' 0 'foobar' pex search foo

ok_program 'pex search abc returns nothing' 0 '' pex search abc

ok_program 'pex search "" returns foobar' 0 'foobar' pex search ""

ok_program 'pex search without arguments returns foobar' 0 'foobar' pex search

ok_program 'pex search with too many arguments errors' 1 'pex: "search" takes zero or one arguments' pex search foo bar

cleanup
