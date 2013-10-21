#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 7

pex init $test_repo_url

ok_program 'pex info initial output' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: not installed" pex info foobar

ok_program 'pex info multiple arguments' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: not installed
foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: not installed" pex info foobar foobar

ok_program 'pex info no arguments errors' 1 'pex: "info" takes at least one argument' pex info

pex install foobar 2>/dev/null

ok_program 'pex info installed output' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: installed" pex info foobar

ok_program 'pex info with alias' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: installed" pex info foobaralias1

sed_in_place "s/foobar-1.0/foobar-1.1/;s/sha1:.*/sha1: $foobar11_sha1/" $tmpdir/home/.local/share/pex/packages/foobar.yaml

ok_program 'pex info outdated output' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.1.tar.gz
status: outdated" pex info foobar

ok_program 'pex info with nonexistent package fails' 1 'pex: package "nonexistent" does not exist' pex info nonexistent

cleanup
