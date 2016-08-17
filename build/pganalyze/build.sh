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
# Copyright 2016 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=collector
VER=0.9.4
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=omniti/database/pganalyze/collector
SUMMARY="$PROG - Go-based daemon which collects various information about Postgres databases as well as queries run on it"
DESC="$SUMMARY"

DEPENDS_IPS=""
BUILD_DEPENDS_IPS="omniti/runtime/go"

GOSRC=go-src
GITHUB_LINK=github.com/pganalyze/collector
export PATH="$PATH:/opt/go/bin"
export GOROOT=/opt/go
export GOPATH="$TMPDIR/$GOSRC"

download_source() {
  logcmd mkdir -p $TMPDIR/$GOSRC
  pushd $TMPDIR/$GOSRC > /dev/null
  logcmd go get $GITHUB_LINK 
  popd > /dev/null
}

build64() {
    make_clean
    make_prog64
    make_install64
}

make_clean(){
    logmsg "Making go binary (64)"
    pushd $TMPDIR/$GOSRC/src/$GITHUB_LINK > /dev/null
    logcmd go clean || logerr "build failed"
    popd > /dev/null
}

make_prog64() {
    logmsg "Making go binary (64)"
    pushd $TMPDIR/$GOSRC/src/$GITHUB_LINK > /dev/null
    logcmd  go build || logerr "build failed"
    popd > /dev/null
}

make_install64() {
    logmsg "Installing libraries (64)"
    logcmd mkdir -p $DESTDIR/opt/omni/bin
    logcmd mv $TMPDIR/$GOSRC/src/$GITHUB_LINK/collector $DESTDIR/opt/omni/bin/collector || logerr "Failed to install Collector"
}

init
download_source
prep_build
patch_source
build64
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
