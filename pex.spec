Name: pex
Version: CHANGEME
Release: 1
Summary: package manager for PostgreSQL
License: MIT
URL: https://github.com/petere/pex
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires: curl, git

%description
Pex is a tool for downloading and installing PostgreSQL extensions
and other packages.  It’s based on Git and standard Unix tools
underneath.

%prep
%setup -q

%build
make prefix=%{_prefix}

%install
rm -rf %{buildroot}
make install prefix=%{_prefix} DESTDIR=%{buildroot}

%check
make check

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%doc README.md
%{_bindir}/*
%{_mandir}/man1/*
