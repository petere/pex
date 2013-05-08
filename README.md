# Pex

Pex is a light-weight package manager for PostgreSQL.

Install a package:

    pex install plproxy

See available packages:

    pex search

It's based on Git and standard Unix tools underneath.

See the man page for the complete usage instructions.

Pex is intended for developers and has support for managing multiple PostgreSQL installations.

Pex has been influenced by [Homebrew](http://mxcl.github.com/homebrew/) but is otherwise unrelated.

[![Build Status](https://secure.travis-ci.org/petere/pex.png)](http://travis-ci.org/petere/pex)

## Installation

You can just get the [pex](https://raw.github.com/petere/pex/master/pex) program directly and install it wherever you want.

The standard installation procedure is:

    git clone git://github.com/petere/pex.git
    cd pex
    sudo make install

This install the `pex` program and the man page under `/usr/local`. See the `Makefile` for more options.

After installation, you must run

    pex init

just once to fetch the initial package descriptions and set up some internal directories.

Pex has minimal run-time dependencies.  You just need a POSIX shell, curl, and git, as well as PostgreSQL, including development headers, and any build dependencies of the packages you want to install.

## How it works

Pex uses a repository of package description files (see below) to know where to download a specific package.  The package description files are (normally) in a Git repository, by default cloned from https://github.com/petere/pex-packages.  So to make changes, use Git tools to make a branch, revert changes, etc.  When asked to install a package, Pex downloads, unpacks, builds, and installs the package into the PostgreSQL installation.  There are command-line options to choose among multiple PostgreSQL installations.

Pex maintains a small amount of state to keep track of what it has already downloaded or installed.  See the man page for the file locations.

If you maintain custom versions of packages or have in-house packages, Pex can support that.  Just edit the repository and change the download URLs or add your own packages.

## Package description file format

Use `pex --repo` to see where the package description files are stored.  See the man page for details.

The package files are in YAML format.  But note that the files are parsed by a shell script, not by a real YAML library, so be gentle. The files must be named `packagename.yaml`.  Here is an example of `plsh.yaml`:

    homepage: https://github.com/petere/plsh
    url: https://github.com/petere/plsh/archive/1.20121226.zip
    sha1: c85166bc04a3a3731c4acc3f144a0d4779f20010

There are three required fields:

* `homepage`: A location that can be opened in a web browser to learn about the package.
* `url`: A location that curl can download and either tar or zip can unpack to get the package source.
* `sha1`: The SHA1 hash of the downloaded archive.

Use `pex audit` to check the package file for syntax and other errors. Note that this requires Perl and the YAML module.
