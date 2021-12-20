#!/bin/sh

set -e

do_compile() {
    kernel_do_compile
}

kernel_do_compile() {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
    oe_runmake Image \
    CC="aarch64-poky-linux-gcc -march=armv8-a+crc -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security --sysroot=/opt/poky/3.0.4/sysroots/aarch64-poky-linux" \
    LD="aarch64-poky-linux-ld --sysroot=/opt/poky/3.0.4/sysroots/aarch64-poky-linux"
}

oe_runmake() {
	oe_runmake_call "$@" 
}

oe_runmake_call() {

    make -j 8 HOSTCC="gcc \
    -O2 -pipe \
    -Wl,--enable-new-dtags \
    -Wl,-rpath-link,/opt/poky/3.0.4/sysroots/aarch64-poky-linux/usr/lib \
    -Wl,-rpath-link,/opt/poky/3.0.4/sysroots/aarch64-poky-linux/lib \
    -Wl,-rpath,/opt/poky/3.0.4/sysroots/aarch64-poky-linux/usr/lib \
    -Wl,-rpath,/opt/poky/3.0.4/sysroots/aarch64-poky-linux/lib -Wl,-O1 \
    -Wl,--allow-shlib-undefined \
    -Wl,--dynamic-linker=/opt/poky/3.0.4/sysroots/x86_64-pokysdk-linux/lib/ld-linux-x86-64.so.2" \
    HOSTCPP="gcc  -E" "$@"
}

set -x

do_compile

exit $ret
