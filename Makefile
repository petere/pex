prefix = /usr/local
bindir = $(prefix)/bin

INSTALL = install -c
INSTALL_SCRIPT = $(INSTALL) -m 755
MKDIR_P = mkdir -p

all:

check:
	$(SHELL) -n pex
	checkbashisms pex

installdirs:
	$(MKDIR_P) $(DESTDIR)$(bindir)

install: all installdirs
	$(INSTALL_SCRIPT) pex $(DESTDIR)$(bindir)/pex

uninstall:
	$(RM) $(DESTDIR)$(bindir)/pex
