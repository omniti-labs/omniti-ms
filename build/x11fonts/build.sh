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
# Copyright 2015 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=x11fonts
VER=1.0     
VERHUMAN=$VER
PKG=omniti/X11/x11fonts
SUMMARY="Font pack for X11"
DESC=$SUMMARY

LDFLAGS="-L/opt/omni/lib -R/opt/omni/lib"
LDFLAGS64="-L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"

DEPENDS_IPS="developer/pkg-config omniti/library/freetype2 omniti/X11/bdftopcf omniti/X11/xproto omniti/X11/libXfont"
BUILD_DEPENDS_IPS=$DEPENDS_IPS

build32() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    for FONT in *; do
      if [ -d "${FONT}" ]; then
	export PKG_CONFIG_PATH="/opt/omni/lib/pkgconfig:/opt/omni/share/pkgconfig"
	pushd $TMPDIR/$BUILDDIR/$FONT > /dev/null
        logmsg "Building 32-bit ${FONT}"
    	export ISALIST="$ISAPART"
    	make_clean
    	configure32
    	make_prog32
    	make_install32
    	popd > /dev/null
    	unset ISALIST
    	export ISALIST
      fi
    done
    popd > /dev/null
}

build64() {
   logmsg "NOOP"
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
