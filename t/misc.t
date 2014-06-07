#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 1

ok_program 'pex without arguments' 1 'pex: usage: pex COMMAND [PACKAGE] (try " --help")' pex

cleanup
