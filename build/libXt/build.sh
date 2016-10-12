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

PROG=libXt
VER=1.1.3
VERHUMAN=$VER
PKG=omniti/X11/libXt
SUMMARY="libXt for X11"
DESC=$SUMMARY

# Set pkg-config path appropriately
save_function build32 build32_orig
build32() {
    export PKG_CONFIG_PATH="/opt/omni/lib/pkgconfig:/opt/omni/share/pkgconfig"
    build32_orig
}

save_function build64 build64_orig
build64() {
    export PKG_CONFIG_PATH="/opt/omni/lib/amd64/pkgconfig:/opt/omni/share/pkgconfig"
    build64_orig
}

DEPENDS_IPS="developer/pkg-config omniti/library/freetype2 omniti/X11/libX11 omniti/X11/xproto omniti/X11/kbproto omniti/X11/libICE omniti/X11/libSM"
BUILD_DEPENDS_IPS=$DEPENDS_IPS

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
