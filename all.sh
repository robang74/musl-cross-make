#!/bin/bash

set -e

export MAKEFLAGS=-j16

if [ ! -e config.mak ]; then
	echo "MUSL_REPO = https://github.com/acammack-r7/musl" > config.mak
	echo "MUSL_VER = git-stealthy-loading" >> config.mak
	cat config.mak.dist >> config.mak
fi

build() {
	make clean
	echo Building $1
	make TARGET=$1 > $1.log
	make TARGET=$1 install >> $1.log
}

build i486-linux-musl
build x86_64-linux-musl
build powerpc-linux-musl
build mips-linux-musl
build mipsle-linux-musl
build aarch64-linux-musl
build arm-linux-musleabi
build arm-linux-musleabihf
build sh2eb-linux-muslfdpic

mv output musl-cross
find musl-cross/bin -type f -executable |xargs strip
find musl-cross/libexec -type f -executable |xargs strip

tar cavf musl-cross.tar.xz musl-cross
