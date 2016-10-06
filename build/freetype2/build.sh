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

PROG=freetype
DOWNLOADDIR=freetype2
VER=2.7
VERHUMAN=$VER
PKG=omniti/library/freetype2
SUMMARY="A Free, High-Quality, and Portable Font Engine"
DESC="$SUMMARY"

DEPENDS_IPS="compress/bzip2 library/zlib"

if (( $RELVER > 151014 )); then
	DEPENDS_IPS+=" system/library/gcc-5-runtime"
else
	DEPENDS_IPS+=" system/library/gcc-4-runtime"
fi

BUILD_DEPENDS_IPS=$DEPENDS_IPS

export GNUMAKE=gmake
LDFLAGS32=-R/opt/omni/lib
LDFLAGS64="-R/opt/omni/lib/amd64"
CONFIGURE_OPTS="--with-png=no"

export PKG_CONFIG_PATH=/opt/omni/lib/pkgconfig

init
download_source $DOWNLOADDIR $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
