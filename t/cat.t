#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 3

pex init $test_repo_url

ok_program 'pex cat foobar works' 0 "homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
sha1: $foobar10_sha1" pex cat foobar

ok_program 'pex cat multiple arguments works' 0 "homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
sha1: $foobar10_sha1
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
sha1: $foobar10_sha1" pex cat foobar foobar

ok_program 'pex cat no argument errors' 1 'pex: "cat" takes at least one argument' pex cat

cleanup
