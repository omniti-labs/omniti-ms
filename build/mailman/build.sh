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

PROG=mailman
VER=2.1.15
VERHUMAN=$VER
PKG=omniti/mail/mailman
SUMMARY="The GNU Mailman mailing list manager"
DESC=$SUMMARY
BUILD_DEPENDS_IPS="omniti/runtime/python-26"
DEPENDS_IPS=$BUILD_DEPENDS_IPS
PREFIX=/opt/mailman
CONFIGURE_OPTS="--prefix=${PREFIX} --with-permcheck=no --with-python=/opt/python26/bin/python --with-cgi-gid=nobody --with-cgi-uid=nobody"

copy_manifest() {
    # SMF manifest
    logmsg "--- Copying SMF manifest"
    logcmd mkdir -p ${DESTDIR}/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/mailman.xml ${DESTDIR}/lib/svc/manifest/network
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
copy_manifest
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
