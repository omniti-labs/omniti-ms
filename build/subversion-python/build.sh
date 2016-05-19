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

PROG=subversion
VER=1.9.2
PKG=omniti/library/python-2/pyswig-27
SUMMARY="pyswig-27 - $PROG Python 2.7 bindings"
DESC="$SUMMARY"

NEON=neon
NVER=0.29.6
export PYTHON=/opt/python27/bin/python

BUILD_DEPENDS_IPS="omniti/runtime/python-27 omniti/developer/swig"
DEPENDS_IPS="omniti/library/apr
             omniti/library/apr-util
	     omniti/developer/versioning/subversion
	     omniti/library/serf
             omniti/server/apache22"

BUILDARCH=64
CPPFLAGS="$CPPFLAGS -I/opt/omni/include" 
LDFLAGS64="$LDFLAGS64 \
    -L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"
CFLAGS="$CFLAGS -std=gnu99"

CONFIGURE_OPTS="$CONFIGURE_OPTS
    --sysconfdir=$PREFIX/etc
    --with-pic
    --with-ssl
    --without-berkeley-db --without-jdk
    --disable-nls
    --with-apxs=/opt/apache22/bin/apxs
    PYTHON=/opt/python27/bin/python"

CONFIGURE_OPTS_64="$CONFIGURE_OPTS_64
    --with-swig=/opt/omni/bin/$ISAPART64/swig
    --with-apr=/opt/omni/bin/$ISAPART64/apr-1-config
    --with-apr-util=/opt/omni/bin/$ISAPART64/apu-1-config
    --with-apxs=/opt/apache22/bin/$ISAPART64/apxs"

save_function download_source download_source_orig
download_source() {
    BUILDDIR=${NEON}-${NVER}
    download_source_orig $NEON $NEON $NVER
    BUILDDIR=${PROG}-${VER}
    download_source_orig $1 $2 $3
    logmsg "Copying neon to subversion source directory"
    logcmd cp -r ${TMPDIR}/${NEON}-${NVER} ${TMPDIR}/${PROG}-${VER}/neon || \
        logerr "Failed to copy neon"
}

save_function make_prog make_prog_orig
make_prog() {
    make_prog_orig
    logcmd /usr/bin/perl -pi -e 's/$/ -lpython2.7/ if /^SWIG_PY_LINK.*(?!lpython2.7)/' Makefile
    make_param swig-py
}

make_install() {
    make_param DESTDIR=${DESTDIR} install-swig-py
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
