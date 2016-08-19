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

PATH=$SRCDIR/bin:$PATH
export PATH

PROG=erlang

OTPVER=19.0
#REPO=git://github.com/slfritchie/otp.git
VER=19.0.0
VERHUMAN=$OTPVER
PKG=omniti/runtime/erlang
SUMMARY="Erlang OTP Platform"
DESC="$SUMMARY ($VERHUMAN)"

TAR=gtar
BUILDDIR=otp_src_$OTPVER
ERL_TOP=$TMPDIR/$BUILDDIR
export ERL_TOP
##
BUILDARCH=64
BUILD_DEPENDS_IPS="archiver/gnu-tar omniti/runtime/perl developer/versioning/git"
DEPENDS_IPS="library/security/openssl developer/dtrace
    system/library system/library/math"
NO_PARALLEL_MAKE=1

CONFIGURE_OPTS32="--prefix=$PREFIX"
CONFIGURE_OPTS="--enable-smp-support
    --enable-dtrace
    --enable-threads
    --with-ssl=/usr
    --enable-dynamic-ssl-lib
    --enable-m64-build"

# This is very stale - should probably be removed
clone_source() {
  pushd $TMPDIR > /dev/null || logerr "Cannot cd to $TMPDIR"
  logmsg "--- Cloning from $REPO"
  logcmd git clone $REPO $BUILDDIR
  pushd $BUILDDIR > /dev/null || logerr "Cannot cd to $BUILDDIR"
  logcmd git pull || logerr "Could not pull -- something wrong with checkout"
  logcmd git reset --hard HEAD || logerr "Couldn't reset checkout to HEAD"
  logmsg " --- pulling dtrace bits"
  logcmd git checkout dtrace-r14b04 || logerr "Could not pull dtrace bits"
  logcmd ./otp_build autoconf || logerr "autoconf failed"
  popd > /dev/null
  popd > /dev/null
}


##########
# Overwrite make_isaexec_stub_arch() from ../../lib/functions.sh.
## (https://github.com/omniti-labs/omniti-ms/blob/master/lib/functions.sh#L709)
# Line 719 does not handle links properly and is creating an incorrect symlink:
## /opt/omni/bin/erl -> ../../lib/amd64/erlang/bin/erl
# To prevent this, we cp instead of mv.
make_isaexec_stub_arch() {
    for file in $1/*; do

        # Deals with empty dirs & non-files
        [[ -f $file ]] || continue

        # Check to make sure we don't have a script
        header=`od -x -N 4 $file | head -1`
        if [ "$header" != "0000000 457f 464c" ]; then
                logmsg "------ Relocating non-binary file $file"
                # This is the relevant change from functions.sh
                cp $file .
                continue
        fi

        file=`echo $file | sed -e "s/$1\///;"`

        # Skip if we already made a stub for this file
        [[ -f $file ]] && continue

        logmsg "------ $file"

        # Run the makeisa.sh script
        CC=$CC \
        logcmd $MYDIR/makeisa.sh $PREFIX/$DIR $file || \
            logerr "--- Failed to make isaexec stub for $DIR/$file"
    done
}
##########


init
if [[ -z "$REPO" ]]; then
  download_source $PROG otp_src_$OTPVER
else
  clone_source
fi

patch_source
prep_build
build
make_isa_stub

# Copy in an XML manifest for the Erlang Port Mapper Daemon
logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/
logcmd cp $SRCDIR/erlang-empd.xml $DESTDIR/lib/svc/manifest/network/

# Setup working dir for epmd
logcmd mkdir -p $DESTDIR/var/lib/epmd
logcmd chown nobody:nobody $DESTDIR/var/lib/epmd

make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
