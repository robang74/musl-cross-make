#!/bin/bash

set -e

export MAKEFLAGS=-j4

build() {
	make clean
	echo Building $1
	make TARGET=$1 > $1.log
	make TARGET=$1 install >> $1.log
}

cp config.mak.dist config.mak
echo 'COMMON_CONFIG += CC="gcc-4.8" CXX="g++-4.8"' > config.mak
rm -fr tools
make clean
make TARGET=i486-linux-musl > toolchain.log
make TARGET=i486-linux-musl install >> toolchain.log
mv output tools
export PATH=`pwd`/tools/bin:$PATH

echo "MUSL_REPO = https://github.com/busterb/musl" > config.mak
echo "MUSL_VER = git-stealthy-loading" >> config.mak
echo 'COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"' >> config.mak
echo 'COMMON_CONFIG += CC="i486-linux-musl-gcc -static --static" CXX="i486-linux-musl-g++ -static --static"' >> config.mak
echo "COMMON_CONFIG += --disable-nls" >> config.mak
echo "GCC_CONFIG += --enable-languages=c,c++" >> config.mak
echo "GCC_CONFIG += --disable-libquadmath --disable-decimal-float" >> config.mak
echo "GCC_CONFIG += --disable-multilib" >> config.mak

build i486-linux-musl
build x86_64-linux-musl
build powerpc-linux-musl
build powerpc64le-linux-musl
build mips-linux-musl
build mipsle-linux-musl
build mips64-linux-muslsf
build aarch64-linux-musl
build arm-linux-musleabi
build arm-linux-musleabihf
build sh2eb-linux-muslfdpic

mv output musl-cross
find musl-cross/bin -type f -executable |xargs strip
find musl-cross/libexec -type f -executable |xargs strip

tar cavf musl-cross.tar.xz musl-cross
