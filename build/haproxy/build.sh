#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=haproxy
VER=1.8.9
VERHUMAN=$VER
PKG=omniti/server/haproxy
SUMMARY="The Reliable, High Performance TCP/HTTP Load Balancer"
DESC="$SUMMARY"

DEPENDS_IPS="library/pcre library/security/openssl library/zlib"
BUILD_DEPENDS_IPS="$DEPENDS_IPS archiver/gnu-tar"

TAR=/usr/gnu/bin/tar
IGNOREGIT=true
export IGNOREGIT
BUILDDIR=${PROG}-${VER}

BUILDARCH=64

# There is no configure, only Zuul
configure64() {
    true
}

make_prog() {
    [[ -n $NO_PARALLEL_MAKE ]] && MAKE_JOBS=""
    logmsg "--- make"
    logcmd $MAKE $MAKE_JOBS \
        TARGET=solaris \
        ARCH=x86_64 \
        USE_OPENSSL=1 \
        USE_ZLIB=1 \
        USE_PCRE=1 \
        USE_REGPARM=1 \
	ADDLIB="-lumem" \
        ADDINC="-I/usr/include/pcre" || \
        logerr "--- Make failed"
}

make_install() {
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} PREFIX=/opt/omni DOCDIR='$(PREFIX)/share/doc/haproxy' install || \
        logerr "--- Make install failed"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
logcmd mkdir -p ${DESTDIR}/lib/svc/manifest/network
logcmd cp $SRCDIR/files/haproxy.xml ${DESTDIR}/lib/svc/manifest/network/haproxy.xml
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
