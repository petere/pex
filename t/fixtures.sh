set -e

srcdir=$PWD

tmpdir=$srcdir/tmp
rm -rf $tmpdir
mkdir -p $tmpdir

cleanup() {
        rm -rf $tmpdir
}

cd $tmpdir


GIT_AUTHOR_NAME=Test
GIT_AUTHOR_EMAIL=test@example.com
GIT_COMMITTER_NAME=Test
GIT_COMMITTER_EMAIL=test@example.com
export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

if which shasum >/dev/null 2>&1; then
	sha1sum=shasum
else
	sha1sum=sha1sum
fi


# make mock directory structure

mkdir -p bin lib/postgresql share/postgresql data

cp $srcdir/pex bin/

cat <<EOF >bin/pg_config
#!/bin/sh
echo $tmpdir/share/postgresql
EOF

cat <<EOF >bin/psql
echo $tmpdir/data
echo \$0 "\$*" 1>&2
EOF

cat <<EOF >bin/rpm
#!/bin/sh
echo postgresql
EOF

cat <<EOF >bin/sudo
#!/bin/sh
echo SUDO "\$@"
EOF

chmod a+x bin/*

PATH=$tmpdir/bin:$PATH

cat <<EOF >data/postmaster.opts
$tmpdir/bin/postgres "-D" "$tmpdir/data"
EOF


# "bad" psql to simulate failures

mkdir $tmpdir/badbin

cat <<EOF >$tmpdir/badbin/psql
#!/bin/sh
exit 2
EOF

chmod a+x $tmpdir/badbin/*


# make mock source tarballs to download

mkdir -p scratch/foobar-1.0
cat <<EOF >scratch/foobar-1.0/Makefile
all:
	echo PG_CONFIG=\$(PG_CONFIG)\$(EXTRA_ALL)
install:
	mkdir -p \$(DESTDIR)$tmpdir/lib/postgresql
	echo foobar >\$(DESTDIR)$tmpdir/lib/postgresql/foobar.so\$(EXTRA_INSTALL)
EOF

tar -C scratch -c -z -f scratch/foobar-1.0.tar.gz foobar-1.0/
foobar10_sha1=$("$sha1sum" scratch/foobar-1.0.tar.gz | cut -d ' ' -f 1)
test -n "$foobar10_sha1"  # sanity check

cp -R scratch/foobar-1.0 scratch/foobar-1.1
tar -C scratch -c -z -f scratch/foobar-1.1.tar.gz foobar-1.1/
foobar11_sha1=$("$sha1sum" scratch/foobar-1.1.tar.gz | cut -d ' ' -f 1)
test -n "$foobar11_sha1"

mkdir -p scratch/zoobar-1.0
cat <<EOF >scratch/zoobar-1.0/Makefile
all: ; echo PG_CONFIG=\$(PG_CONFIG)
install: ; echo zoobar >$tmpdir/lib/postgresql/zoobar.so
EOF

tar -C scratch -c -z -f scratch/zoobar-1.0.tar.gz zoobar-1.0/
zoobar10_sha1=$("$sha1sum" scratch/zoobar-1.0.tar.gz | cut -d ' ' -f 1)
test -n "$zoobar10_sha1"



# make mock repo to clone

mkdir -p repo
cd repo
git init -q

cat <<EOF >foobar.yaml
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
sha1: $foobar10_sha1
EOF
git add foobar.yaml
git commit -m 'Add foobar package' -q

cat <<EOF >zoobar.yaml
homepage: http://www.example.net/
url: file://$tmpdir/scratch/zoobar-1.0.tar.gz
sha1: $zoobar10_sha1
EOF
git add zoobar.yaml
git commit -m 'Add zoobar package' -q

cd ..

test_repo_url=$tmpdir/repo


# make fake home directory

mkdir -p home
HOME=$tmpdir/home


sed_in_place() {
	local pattern="$1"
	local file="$2"

	sed "$pattern" "$file" >"$file".new && mv "$file.new" "$file"
}

set +e
