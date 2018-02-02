#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=httpd
VER=2.4.29
PKG=omniti/server/apache24
SUMMARY="$PROG - Apache Web Server ($VER)"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="database/sqlite-3 library/security/openssl omniti/library/apr omniti/library/apr-util omniti/library/nghttp2"
DEPENDS_IPS="omniti/library/apr@1.5 \
             omniti/library/apr-util@1.5
             omniti/library/nghttp2 \
             library/security/openssl \
             database/sqlite-3"

PREFIX=/opt/apache24
reset_configure_opts

# Package info
NAME=Apache
CATEGORY=network

BUILDARCH=64
MIRROR=archive.apache.org
DIR=dist/httpd # Mirror directory to download from

# Define some architecture specific variables
if [[ $ISAPART == "i386" ]]; then
    LAYOUT64=SolAmd64
    #DEF64="-DALTLAYOUT -DAMD64"
else
    # sparc
    LAYOUT64=SolSparc64
    #DEF64="-DALTLAYOUT -DSPARCV9"
fi

# General configure options - BASE is for options to be applied everywhere
# and the *64 variables are for 64 bit builds.
CONFIGURE_OPTS_BASE="--with-mpm=prefork
    --enable-mpms-shared=all
    --enable-mods-shared=reallyall"

CONFIGURE_OPTS_64="$CONFIGURE_OPTS_BASE
    --enable-layout=$LAYOUT64
    --with-apr=/opt/omni/bin/$ISAPART64/apr-1-config
    --with-apr-util=/opt/omni/bin/$ISAPART64/apu-1-config"

LDFLAGS64="$LDFLAGS64 -L/opt/omni/lib/$ISAPART64 -R/opt/omni/lib/$ISAPART64"
CFLAGS64="$CFLAGS64 -I/opt/omni/include/$ISAPART64 -g"

overlay_root() {
    (cd $SRCDIR/root && tar cf - .) | (cd $DESTDIR && tar xf -)
}

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
    logcmd rm -f $DESTDIR$PREFIX/conf/httpd.*.conf
    logcmd mv $DESTDIR$PREFIX/conf/httpd.conf $DESTDIR$PREFIX/conf/httpd.conf.dist
    add_file httpd.conf conf/httpd.conf
}

# Add some more files once the source code has been downloaded
save_function download_source download_source_orig
download_source() {
    download_source_orig "$@"
    logcmd cp $SRCDIR/files/config.layout $TMPDIR/$BUILDDIR/
}

# Add another step after patching the source (a new file needs to be made
# executable
save_function patch_source patch_source_orig
patch_source() {
    patch_source_orig
    logcmd chmod +x $TMPDIR/$BUILDDIR/libtool-dep-extract
}

init
download_source $DIR $PROG $VER
patch_source
prep_build
build
overlay_root
make_isa_stub
add_extra_files
make_package
clean_up
