TARGET = arm-linux-musleabi
OUTPUT = ${PWD}/../toolchain
BINUTILS_VER = 2.27
GCC_VER = 5.3.0
MPFR_VER = 3.1.3
MUSL_VER = git-master
LINUX_VER =
COMMON_CONFIG += --enable-gold --disable-nls
COMMON_CONFIG += --with-debug-prefix-map=$(PWD)=
GCC_CONFIG += --disable-libquadmath --disable-decimal-float
GCC_CONFIG += --enable-languages=c,c++,lto --enable-default-pie
