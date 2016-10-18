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

PROG=libgd
VER=2.2.3
VERHUMAN=$VER
PKG=omniti/library/gd
SUMMARY="$PROG - GD Graphics Library"
DESC="$SUMMARY"

DEPENDS_IPS="omniti/library/libjpeg =omniti/library/libjpeg
             omniti/library/libpng =omniti/library/libpng"

LDFLAGS32="-L/opt/omni/lib -R/opt/omni/lib"
LDFLAGS64="-L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"
CONFIGURE_OPTS="--with-png=/opt/omni 
		--enable-werror=no
                --with-freetype=/opt/omni
                --without-fontconfig 
                --with-jpeg 
                --without-libiconv-prefix"
CPPFLAGS="-I/opt/omni/include/"

export LIBPNG_CONFIG="/opt/omni/bin/libpng-config"

run_bootstrap() {
	logmsg "Running $PROG bootstrap script"
	pushd $TMPDIR/$BUILDDIR > /dev/null
	logcmd ./bootstrap.sh || logerr "Failed to run ./bootstrap.sh"
	popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
run_bootstrap
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
