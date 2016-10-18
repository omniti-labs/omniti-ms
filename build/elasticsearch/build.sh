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
# Copyright 2011-2013 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=elasticsearch
VER=2.4.1
PKG=omniti/system/elasticsearch
SUMMARY="ElasticSearch - Open Source, Distributed, RESTful, Search Engine"
DESC="$SUMMARY"
PREFIX=/opt/elasticsearch

NO_AUTO_DEPENDS=true

build() {
    logmsg "Installing files"
    logmsg "--- Elasticsearch files"
    logcmd mkdir -p $DESTDIR/$PREFIX
    logcmd cp -rf $TMPDIR/$PROG-$VER/* $DESTDIR/$PREFIX
    logcmd mkdir -p $DESTDIR/$PREFIX/plugins
    logcmd mkdir -p $DESTDIR/$PREFIX/config/scripts

    logmsg "Installing SMF manifest"
    logmsg "--- Elasticsearch SMF"
    logcmd mkdir -p ${DESTDIR}/lib/svc/manifest/system
    logcmd cp $SRCDIR/files/elasticsearch.xml ${DESTDIR}/lib/svc/manifest/system/ || \
        logerr "failed to install SMF"
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
