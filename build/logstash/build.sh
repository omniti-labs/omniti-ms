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

PROG=logstash   # App name
VER=2.4.0       # App version
VERHUMAN=$VER   # Human-readable version
PKG=omniti/network/logstash # Package name (e.g. library/foo)
SUMMARY="Logstash log management tool"      # One-liner, must be filled in
DESC="logstash is a tool for managing events and logs. You can use it to collect logs, parse them, and store them for later use (like, for searching)"
PREFIX=/opt/logstash # Custom prefix

NO_AUTO_DEPENDS=true

build() {
    logmsg "Installing files"
    logmsg "--- Logstash files"
    logcmd mkdir -p $DESTDIR/$PREFIX
    logcmd cp -rf $TMPDIR/$PROG-$VER/* $DESTDIR/$PREFIX

    logmsg "--- SMF manifest"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/logstash.xml $DESTDIR/lib/svc/manifest/network
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/method-logstash $DESTDIR/lib/svc/method/logstash

    logmsg "--- Sample config"
    logcmd cp $SRCDIR/files/logstash.conf.sample $DESTDIR/$PREFIX
}

init
download_source $PROG $PROG $VER
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
