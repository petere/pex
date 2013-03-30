#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 9

ok 'pex init succeeds' pex init $test_repo_url

ok_program 'pex audit succeeds' 0 '==> Auditing foobar
==> Auditing zoobar
==> Looks good' pex audit

ok_program 'pex audit foobar succeeds' 0 '==> Auditing foobar
==> Looks good' pex audit foobar

# make a mess ...
sed 's/url/abc/' $tmpdir/home/.local/share/pex/packages/foobar.yaml >$tmpdir/home/.local/share/pex/packages/barbar.yaml
pex audit barbar 2>/dev/null
ok 'pex audit barbar fails due to missing url' test $? -ne 0

pex audit 2>/dev/null
ok 'pex audit fails' test $? -ne 0

sed 's/homepage: .*$/hompage: FIXME/' $tmpdir/home/.local/share/pex/packages/foobar.yaml >$tmpdir/home/.local/share/pex/packages/barbar.yaml
pex audit barbar 2>/dev/null
ok 'pex audit barbar fails due to fixme homepage' test $? -ne 0

sed 's/homepage: .*$/hompage: /' $tmpdir/home/.local/share/pex/packages/foobar.yaml >$tmpdir/home/.local/share/pex/packages/barbar.yaml
pex audit barbar 2>/dev/null
ok 'pex audit barbar fails due to empty homepage' test $? -ne 0

sed 's/homepage/abc/' $tmpdir/home/.local/share/pex/packages/foobar.yaml >$tmpdir/home/.local/share/pex/packages/barbar.yaml
pex audit barbar 2>/dev/null
ok 'pex audit barbar fails due to missing homepage' test $? -ne 0

sed 's/sha1/abc/' $tmpdir/home/.local/share/pex/packages/foobar.yaml >$tmpdir/home/.local/share/pex/packages/barbar.yaml
pex audit barbar 2>/dev/null
ok 'pex audit barbar fails due to missing sha1' test $? -ne 0

cleanup
