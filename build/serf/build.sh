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

PROG=serf
VER=1.3.8
VERHUMAN=$VER   # Human-readable version
PKG=omniti/library/serf
SUMMARY="serf WebDav client library"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="developer/swig omniti/library/python-2/scons omniti/library/apr omniti/library/apr-util"
DEPENDS_IPS="omniti/library/apr-util"

PREFIX=/opt/omni

SCONS="/opt/python26/bin/scons"

GCC_PATH="/opt/gcc-4.8.1/bin/gcc"

SCONS_CONFIG_FILE=".saved_config"

scons_conf_32() {
echo "PREFIX = '/opt/omni'
LIBDIR = 'opt/omni/lib'
APR = '/opt/omni/bin/i386/apr-1-config'
APU = '/opt/omni/bin/i386/apu-1-config'
CC = ['/opt/gcc-4.8.1/bin/gcc']
CFLAGS = ['-m32', '-fPIC']
LINKFLAGS = ['-m32', '-L/opt/omni/lib', '-R/opt/omni/lib', '-fPIC', '-shared']
CPPFLAGS = ['-D__EXTENSIONS__', '-L/opt/omni/lib', '-R/opt/omni/lib', '-D__EXTENSIONS__', '-D_LARGEFILE_SOURCE', '-D_FILE_OFFSET_BITS=64', '-D_LARGEFILE64_SOURCE']" > $SCONS_CONFIG_FILE
}

scons_conf_64() {
echo "PREFIX = '/opt/omni'
LIBDIR = 'opt/omni/lib/amd64'
APR = '/opt/omni/bin/amd64/apr-1-config'
APU = '/opt/omni/bin/amd64/apu-1-config'
CC = ['/opt/gcc-4.8.1/bin/gcc']
CFLAGS = ['-m64', '-fPIC']
LINKFLAGS = ['-m64', '-L/opt/omni/lib/amd64', '-R/opt/omni/lib/amd64', '-fPIC', '-shared']
CPPFLAGS = ['-D__EXTENSIONS__', '-L/opt/omni/lib/amd64', '-R/opt/omni/lib/amd64', ' -D__EXTENSIONS__']" > $SCONS_CONFIG_FILE
}

configure32() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    scons_conf_32
    logcmd $SCONS || \
        logerr "--- Configure failed"
}
configure64() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    scons_conf_64
    logcmd $SCONS || \
        logerr "--- Configure failed"
}
make_prog() {
    logmsg "--- make (noop)"
}
make_install() {
    logmsg "--- scons install"
    logcmd $SCONS install --install-sandbox=$DESTDIR || \
        logerr "--- scons install failed"
}
make_clean() {
    logmsg "--- scons clean"
    logcmd $SCONS --clean || \
        logmsg "--- *** WARNING *** scons clean Failed"
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
