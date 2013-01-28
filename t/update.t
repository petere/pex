#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 3

pex init $test_repo_url

ok 'pex update runs' pex update

ok 'old package available' grep -q 'example.com' "$HOME/.local/share/pex/packages/foobar.yaml"

cd $tmpdir/repo
sed -i 's/example.com/example.net/' foobar.yaml
git commit -m 'Test update' foobar.yaml
cd -

pex update

ok 'new package available' grep -q 'example.net' "$HOME/.local/share/pex/packages/foobar.yaml"

cleanup
