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

PROG=opendkim   # App name
VER=2.10.3      # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=omniti/network/smtp/opendkim   # Package name (e.g. library/foo)
SUMMARY="Open source implementation of DKIM"      # One-liner, must be filled in
DESC="$SUMMARY"         # Longer description, must be filled in

# Extra script/file installs
add_file() {
    logcmd cp $SRCDIR/files/$1 $DESTDIR$PREFIX/$2
    logcmd chown root:root $DESTDIR$PREFIX/$2
    if [[ -n "$3" ]]; then
        logcmd chmod $3 $DESTDIR$PREFIX/$2
    else
        logcmd chmod 0444 $DESTDIR$PREFIX/$2
    fi
}

add_extra_files() {
    logmsg "Installing custom files and scripts"
    logcmd mkdir $DESTDIR$PREFIX/etc
    add_file manifest-smtp-opendkim.xml etc/smtp-opendkim.xml
    add_file opendkim.conf etc/opendkim.conf
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_extra_files
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
