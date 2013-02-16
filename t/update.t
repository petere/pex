#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 4

pex init $test_repo_url

ok 'pex update runs' pex update

ok 'old package available' grep -q 'example.com' "$HOME/.local/share/pex/packages/foobar.yaml"

cd $tmpdir/repo
sed_in_place 's/example.com/example.net/' foobar.yaml
git commit -m 'Test update' foobar.yaml
cp foobar.yaml barbar.yaml
git add barbar.yaml
git commit -m 'Test update'
cd -

pex update 2>/dev/null | sed 1d >pex-update.out
# (skip "Updating xxx..yyy" line)

ok 'new package available' grep -q 'example.net' "$HOME/.local/share/pex/packages/foobar.yaml"
ok 'pex update output' test "$(cat pex-update.out)" = 'Fast-forward
==> New packages
barbar
==> Updated packages
foobar'

cleanup
