# Noddy Makefile for dist
# $Id$

VERSION = 0.17

bindir = /usr/sbin
sysconfdir = /etc
docdir = /usr/share/doc/tenshi-${VERSION}
mandir = /usr/share/man
libdir = /var/lib/tenshi

DOCS = README.md LICENSE Changelog
SAMPLES = tenshi.conf tenshi.debian-init tenshi.openrc-init
BIN = Makefile tenshi
MAN = tenshi.8

DIST_DIR = tenshi-${VERSION}
TARBALL = tenshi-${VERSION}.tar.gz

FILES = ${DOCS} ${SAMPLES} ${BIN} ${MAN}

all: ${FILES}

clean:
	rm -rf tenshi-*.tar.gz

dist: ${TARBALL}

${TARBALL}:
	mkdir -p ${DIST_DIR}
	cp ${FILES} ${DIST_DIR}
	tar czvf tenshi-${VERSION}.tar.gz ${DIST_DIR}
	rm -rf ${DIST_DIR}

install:
	mkdir -p ${DESTDIR}${bindir}
	install tenshi ${DESTDIR}${bindir}/tenshi
	if [ ! -f ${DESTDIR}${sysconfdir}/tenshi/tenshi.conf ]; then \
		mkdir -p ${DESTDIR}${sysconfdir}/tenshi && \
		install -g root -m 0644 tenshi.conf ${DESTDIR}${sysconfdir}/tenshi/tenshi.conf; \
	fi
	install -d ${DESTDIR}${docdir}
	install -m 0644 ${DOCS} ${DESTDIR}${docdir}/
	[ -d ${DESTDIR}${mandir}/man8 ] || \
		install -d ${DESTDIR}${mandir}/man8
	install -g root -m 0644 tenshi.8 ${DESTDIR}${mandir}/man8/
	install -g root -m 755 -d ${DESTDIR}${libdir}
