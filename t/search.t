#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 5

pex init $test_repo_url

ok_program 'pex search foo returns foobar and foobaralias{1,2}' 0 'foobar
foobaralias1
foobaralias2' pex search foo

ok_program 'pex search abc returns nothing' 0 '' pex search abc

ok_program 'pex search "" returns everything' 0 'foobar
foobaralias1
foobaralias2
zoobar' pex search ""

ok_program 'pex search without arguments returns foobar and zoobar' 0 'foobar
zoobar' pex search

ok_program 'pex search with too many arguments errors' 1 'pex: "search" takes zero or one arguments' pex search foo bar

cleanup
