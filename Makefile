prefix = /usr/local
bindir = $(prefix)/bin
datadir = $(prefix)/share
mandir = $(datadir)/man

INSTALL = install -c
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_SCRIPT = $(INSTALL) -m 755
MKDIR_P = mkdir -p

all:

check test:
	prove

maintainer-check:
	$(SHELL) -n pex
	lexgrog pex.1 >/dev/null
	man --warnings=w -l pex.1 >/dev/null

installdirs:
	$(MKDIR_P) $(DESTDIR)$(bindir) $(DESTDIR)$(mandir)/man1

install: all installdirs
	$(INSTALL_SCRIPT) pex $(DESTDIR)$(bindir)/pex
	$(INSTALL_DATA) pex.1 $(DESTDIR)$(mandir)/man1/pex.1

uninstall:
	$(RM) $(DESTDIR)$(bindir)/pex $(DESTDIR)$(mandir)/man1/pex.1
