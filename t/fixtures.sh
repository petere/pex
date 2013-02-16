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

chmod a+x bin/pg_config bin/psql

PATH=$tmpdir/bin:$PATH

cat <<EOF >data/postmaster.opts
$tmpdir/bin/postgres "-D" "$tmpdir/data"
EOF


# make mock source tarball to download

mkdir -p scratch/foobar-1.0
cat <<EOF >scratch/foobar-1.0/Makefile
all: ; echo PG_CONFIG=\$(PG_CONFIG)
install: ; echo foobar >$tmpdir/lib/postgresql/foobar.so
EOF

tar -C scratch -c -z -f scratch/foobar-1.0.tar.gz foobar-1.0/
foobar10_sha1=$(sha1sum scratch/foobar-1.0.tar.gz | cut -d ' ' -f 1)

cp -R scratch/foobar-1.0 scratch/foobar-1.1
tar -C scratch -c -z -f scratch/foobar-1.1.tar.gz foobar-1.1/
foobar11_sha1=$(sha1sum scratch/foobar-1.1.tar.gz | cut -d ' ' -f 1)


# make mock repo to clone

mkdir -p repo
cd repo
git init
cat <<EOF >foobar.yaml
homepage: http://www.example.com/
url: file://$tmpdir/scratch/foobar-1.0.tar.gz
sha1: $foobar10_sha1
EOF
git add foobar.yaml
git commit -m 'Add foobar package'
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
