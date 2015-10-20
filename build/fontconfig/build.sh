#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=fontconfig
VER=2.11.1
VERHUMAN=$VER
PKG=omniti/library/fontconfig
SUMMARY="Fontconfig - Font configuration and customization library"
DESC="$SUMMARY"

DEPENDS_IPS="library/expat omniti/library/freetype2 system/library omniti/X11/x11fonts"

export PKG_CONFIG_PATH="/opt/omni/lib/pkgconfig:/opt/omni/share/pkgconfig"

LDFLAGS="-L/opt/omni/lib -R/opt/omni/lib"
LDFLAGS64="-L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"

CONFIGURE_OPTS="
    --with-confdir=/etc/fonts
    --with-default-fonts='/usr/share/fonts'
    --with-add-fonts=/etc/X11/fontpath.d,/usr/share/ghostscript/fonts,/usr/X11/lib/X11/fonts,/opt/omni/share/fonts/X11
    --with-cache-dir=/var/cache/fontconfig
"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
fix_permissions
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
