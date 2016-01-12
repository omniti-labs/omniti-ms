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

PROG=oauth2client # App name
VER=1.5.2         # App version
VERHUMAN=$VER   # Human readable version
PKG=omniti/library/python-2/oauth2client
SUMMARY="Python module for making OAuth 2.0 connections"
DESC="This is a client library for accessing resources protected by OAuth 2.0."

LDFLAGS64="-L$PYTHONLIB -R$PYTHONLIB -L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"
BUILDARCH=64
PYTHON=/opt/python26/bin/python
PATH=/opt/omni/bin:/opt/python26/bin:$PATH

DEPENDS_IPS="omniti/runtime/python-26"
BUILD_DEPENDS_IPS="$DEPENDS_IPS omniti/library/python-2/setuptools" 

init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
make_package
clean_up
