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

PROG=six # App name
VER=1.10.0        # App version
VERHUMAN=$VER   # Human readable version
PKG=omniti/library/python-27/six
SUMMARY="Python module for smoothing over the differences between the Python versions"
DESC="Python 2/3 compatibility library providing functions to smooth out differences between Python versions with the goal of writing Python code that is compatible on both Python versions."

LDFLAGS64="-L$PYTHONLIB -R$PYTHONLIB -L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"
BUILDARCH=64
PYTHON=/opt/python27/bin/python
PATH=/opt/omni/bin:/opt/python27/bin:$PATH

DEPENDS_IPS="omniti/runtime/python-27"
BUILD_DEPENDS_IPS="$DEPENDS_IPS" 

init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
make_package
clean_up
