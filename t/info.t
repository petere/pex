#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 3

pex init $test_repo_url

ok_program 'pex info initial output' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: not installed" pex info foobar

pex install foobar 2>/dev/null

ok_program 'pex info initial output' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
status: installed" pex info foobar

sed -i "s/foobar-1.0/foobar-1.1/;s/sha1:.*/sha1: $foobar11_sha1/" $tmpdir/home/.local/share/pex/packages/foobar.yaml

ok_program 'pex info initial output' 0 "foobar
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.1.tar.gz
status: outdated" pex info foobar

cleanup
