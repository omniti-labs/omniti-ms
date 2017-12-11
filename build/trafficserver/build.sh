#!/usr/bin/bash

# Load support functions
. ../../lib/functions.sh

PROG=trafficserver
VER=7.1.1
PKG=omniti/server/trafficserver
SUMMARY="Apache Traffic Server - HTTP cache"
DESC="$SUMMARY"

PREFIX="/opt/ts"
reset_configure_opts

[[ $BUILDARCH == 'both' ]] && BUILDARCH=64

## So pkg-config can find our .pc database files
export PKG_CONFIG_PATH=/opt/omni/lib/pkgconfig:/usr/lib/pkgconfig

BUILD_DEPENDS_IPS="\
    compress/xz \
    library/zlib \
    library/expat \
    library/readline \
    library/security/openssl \
    library/pcre database/sqlite-3 \
    omniti/runtime/tcl-8 \
    omniti/system/hwloc"

DEPENDS_IPS="\
    ${BUILD_DEPENDS_IPS} \
    system/library/gcc-4-runtime \
    system/library/g++-4-runtime"

LDFLAGS64="\
    -L/opt/omni/lib/${ISAPART64} \
    -R/opt/omni/lib/${ISAPART64} \
    -R$PREFIX/lib \
    -lumem"

CPPFLAGS="-I/opt/omni/include -I/usr/include/pcre"
CPPFLAGS64="-D__WORDSIZE=64 -I/opt/omni/include/amd64"

CONFIGURE_OPTS="\
    --with-event-interface=port \
    --disable-silent-rules \
    --with-tcl=/opt/omni/lib/${ISAPART64} \
    --enable-experimental-plugins \
    --enable-wccp \
    --enable-test-tools \
    --with-user=ats \
    --with-group=ats"

# Custom configure_opts_64 - we don't want amd64 suffixes (single arch build)
CONFIGURE_OPTS_64="\
    --prefix=${PREFIX} \
    --sysconfdir=${PREFIX}/etc \
    --includedir=${PREFIX}/include \
    --bindir=${PREFIX}/bin \
    --sbindir=${PREFIX}/sbin \
    --libdir=${PREFIX}/lib \
    --libexecdir=${PREFIX}/libexec \
    --mandir=${PREFIX}/share/man \
    --enable-experimental-plugins"

run_autoreconf() {
    logmsg "Running autoreconf"
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logcmd autoreconf -fi || logerr "Failed to run autoreconf"
    popd > /dev/null
}

install_manifest() {
    logmsg "Placing SMF manifest"
    logcmd mkdir -p $DESTDIR/var/svc/manifest/network/http || \
        logerr "--- failed to create manifest directory"
    logcmd cp $SRCDIR/files/trafficserver.xml \
        $DESTDIR/var/svc/manifest/network/http || \
        logerr "--- failed to install manifest"
}

install_method() {
    logmsg "Placing SMF method script"
    logcmd mkdir -p $DESTDIR/lib/svc/method || \
        logerr "--- failed to create manifest directory"
    logcmd cp $SRCDIR/files/trafficserver.method \
        $DESTDIR/lib/svc/method/trafficserver || \
        logerr "--- failed to install method script"
}

install_config() {
    logmsg "Placing default config files"
    logcmd cp $SRCDIR/files/records.config \
        $DESTDIR/opt/ts/etc/records.config || \
        logerr "--- failed to install records.config"
# For ATS 7.x we can use this remap.config.
    logcmd cp $SRCDIR/files/remap.config \
        $DESTDIR/opt/ts/etc/remap.config || \
        logerr "--- failed to install remap.config"
}

make_install() {
    logmsg "--- sudo make install"
    logcmd $MAKE DESTDIR=${DESTDIR} \
	pkgsysuser=$USER \
	pkgsysgroup=`groups | awk '{print $1;}'` \
	install || \
        	logerr "--- Make install failed"
}

init
download_source apache/$PROG $PROG $VER
patch_source
run_autoreconf
prep_build
build
install_method
install_manifest
install_config
make_package
clean_up
