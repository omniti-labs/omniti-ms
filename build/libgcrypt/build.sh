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

PROG=libgcrypt
VER=1.7.10
VERHUMAN=$VER
PKG=omniti/security/libgcrypt
SUMMARY="libgcrypt - cryptographic library"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="omniti/security/libgpg-error"
DEPENDS_IPS="omniti/security/libgpg-error system/library system/library/gcc-4-runtime"

LDFLAGS="-L/opt/omni/lib -R/opt/omni/lib"
LDFLAGS64="-L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"
CPPFLAGS64="${CPPFLAGS64} -Wa,--divide"

CONFIGURE_OPTS="--disable-static"
CONFIGURE_OPTS_64="${CONFIGURE_OPTS_64} --build=x86_64-pc-solaris2.11"

PATH64="/opt/omni/bin/amd64:${PATH}"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build32
export PATH=${PATH64}
build64
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
