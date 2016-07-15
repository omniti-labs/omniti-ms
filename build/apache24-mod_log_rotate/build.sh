#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

## This is mod_log_rotate for Apache 2.x ##

PROG=mod_log_rotate
VER=2
PKG=omniti/server/apache24/mod_log_rotate
SUMMARY="$PROG - Apache Log Rotation Module"
DESC="$SUMMARY"

DEPENDS_IPS="omniti/server/apache24"
BUILD_DEPENDS_IPS="omniti/server/apache24"

unset PREFIX
BUILDARCH=64

build64() {
  local APXS=/opt/apache24/bin/apxs
  logmsg "Building 64-bit"
  logcmd $APXS -c ${PROG}.c || \
    logerr "--- build failed"
  logcmd mkdir -p $DESTDIR`$APXS -q LIBEXECDIR`
  logcmd cp .libs/${PROG}.so $DESTDIR`$APXS -q LIBEXECDIR`/${PROG}.so || \
    logerr "--- install failed"
  logmsg "Cleaning up"
  logcmd rm -f ${PROG}.[osl]*
  logcmd rm -rf .libs
}

init
prep_build
build
make_package
clean_up
