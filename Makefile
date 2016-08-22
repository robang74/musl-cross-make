
OUTPUT = $(PWD)/output
<<<<<<< HEAD
=======
TARGET = sh2eb-linux-musl
>>>>>>> sabotage-linux/support_gcc4
SOURCES = sources

CONFIG_SUB_REV = 3d5db9ebe860
BINUTILS_VER = 2.25.1
GCC_VER = 5.3.0
MUSL_VER = 1.1.15
GMP_VER = 6.1.1
MPC_VER = 1.0.3
MPFR_VER = 3.1.4
LINUX_VER = 4.4.10

GNU_SITE = https://ftp.gnu.org/pub/gnu
GCC_SITE = $(GNU_SITE)/gcc
BINUTILS_SITE = $(GNU_SITE)/binutils
GMP_SITE = $(GNU_SITE)/gmp
MPC_SITE = $(GNU_SITE)/mpc
MPFR_SITE = $(GNU_SITE)/mpfr
ISL_SITE = http://isl.gforge.inria.fr/

<<<<<<< HEAD
MUSL_SITE = http://www.musl-libc.org/releases
MUSL_REPO = git://git.musl-libc.org/musl
=======
BINUTILS_CONFIG = $(COMMON_CONFIG)
GCC_MULTILIB_CONFIG = --disable-multilib --with-multilib-list=
ifeq ($(TARGET),x86_64-x32-linux-musl)
GCC_MULTILIB_CONFIG = --with-multilib-list=mx32
endif
GCC_LANG_CONFIG = --enable-languages=c,c++,lto
GCC_CONFIG = $(COMMON_CONFIG) --enable-tls \
	--disable-libmudflap --disable-libsanitizer \
	--disable-libquadmath --disable-decimal-float \
	--with-target-libiberty=no --with-target-zlib=no \
	--with-system-zlib \
	$(GCC_LANG_CONFIG) \
	$(GCC_MULTILIB_CONFIG)

ifeq ($(TARGET),powerpc-linux-musl)
GCC_CONFIG += --with-long-double-64
endif
>>>>>>> sabotage-linux/support_gcc4

LINUX_SITE = https://cdn.kernel.org/pub/linux/kernel

BUILD_DIR = build-$(TARGET)

-include config.mak

SRC_DIRS = gcc-$(GCC_VER) binutils-$(BINUTILS_VER) musl-$(MUSL_VER) \
	$(if $(GMP_VER),gmp-$(GMP_VER)) \
	$(if $(MPC_VER),mpc-$(MPC_VER)) \
	$(if $(MPFR_VER),mpfr-$(MPFR_VER)) \
	$(if $(ISL_VER),isl-$(ISL_VER)) \
	$(if $(LINUX_VER),linux-$(LINUX_VER))

all:

clean:
	rm -rf gcc-* binutils-* musl-* gmp-* mpc-* mpfr-* isl-* build-* linux-*

distclean: clean
<<<<<<< HEAD
	rm -rf sources


# Rules for downloading and verifying sources. Treat an external SOURCES path as
# immutable and do not try to download anything into it.

ifeq ($(SOURCES),sources)

$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/gmp*)): SITE = $(GMP_SITE)
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/mpc*)): SITE = $(MPC_SITE)
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/mpfr*)): SITE = $(MPFR_SITE)
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/isl*)): SITE = $(ISL_SITE)
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/binutils*)): SITE = $(BINUTILS_SITE)
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/gcc*)): SITE = $(GCC_SITE)/$(basename $(basename $(notdir $@)))
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/musl*)): SITE = $(MUSL_SITE)
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/linux-4*)): SITE = $(LINUX_SITE)/v4.x
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/linux-3*)): SITE = $(LINUX_SITE)/v3.x
$(patsubst hashes/%.sha1,$(SOURCES)/%,$(wildcard hashes/linux-2.6*)): SITE = $(LINUX_SITE)/v2.6

$(SOURCES):
	mkdir -p $@

$(SOURCES)/config.sub: | $(SOURCES)
	mkdir -p $@.tmp
	cd $@.tmp && wget -c -O $(notdir $@) "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=$(CONFIG_SUB_REV)"
	cd $@.tmp && touch $(notdir $@)
	cd $@.tmp && sha1sum -c $(PWD)/hashes/$(notdir $@).$(CONFIG_SUB_REV).sha1
	mv $@.tmp/$(notdir $@) $@
	rm -rf $@.tmp

$(SOURCES)/%: hashes/%.sha1 | $(SOURCES)
	mkdir -p $@.tmp
	cd $@.tmp && wget -c -O $(notdir $@) $(SITE)/$(notdir $@)
	cd $@.tmp && touch $(notdir $@)
	cd $@.tmp && sha1sum -c $(PWD)/hashes/$(notdir $@).sha1
	mv $@.tmp/$(notdir $@) $@
	rm -rf $@.tmp

endif


# Rules for extracting and patching sources, or checking them out from git.

musl-git-%:
	rm -rf $@.tmp
	git clone -b $(patsubst musl-git-%,%,$@) $(MUSL_REPO) $@.tmp
	cd $@.tmp && git fsck
	mv $@.tmp $@

%: $(SOURCES)/%.tar.gz | $(SOURCES)/config.sub
	rm -rf $@.tmp
	mkdir $@.tmp
	( cd $@.tmp && tar zxf - ) < $<
	test ! -d patches/$@ || cat patches/$@/* | ( cd $@.tmp/$@ && patch -p1 )
	test ! -f $@.tmp/$@/config.sub || cp -f $(SOURCES)/config.sub $@.tmp/$@
	rm -rf $@
	touch $@.tmp/$@
	mv $@.tmp/$@ $@
	rm -rf $@.tmp

%: $(SOURCES)/%.tar.bz2 | $(SOURCES)/config.sub
	rm -rf $@.tmp
	mkdir $@.tmp
	( cd $@.tmp && tar jxf - ) < $<
	test ! -d patches/$@ || cat patches/$@/* | ( cd $@.tmp/$@ && patch -p1 )
	test ! -f $@.tmp/$@/config.sub || cp -f $(SOURCES)/config.sub $@.tmp/$@
	rm -rf $@
	touch $@.tmp/$@
	mv $@.tmp/$@ $@
	rm -rf $@.tmp

%: $(SOURCES)/%.tar.xz | $(SOURCES)/config.sub
	rm -rf $@.tmp
	mkdir $@.tmp
	( cd $@.tmp && tar Jxf - ) < $<
	test ! -d patches/$@ || cat patches/$@/* | ( cd $@.tmp/$@ && patch -p1 )
	test ! -f $@.tmp/$@/config.sub || cp -f $(SOURCES)/config.sub $@.tmp/$@
	rm -rf $@
	touch $@.tmp/$@
	mv $@.tmp/$@ $@
	rm -rf $@.tmp

extract_all: | $(SRC_DIRS)


# Rules for building.

ifeq ($(TARGET),)

all:
	@echo TARGET must be set via config.mak or command line.
	@exit 1

else

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/Makefile: | $(BUILD_DIR)
	ln -sf ../litecross/Makefile $@

$(BUILD_DIR)/config.mak: | $(BUILD_DIR)
	printf >$@ -- '%s\n' \
	"MUSL_SRCDIR = ../musl-$(MUSL_VER)" \
	"GCC_SRCDIR = ../gcc-$(GCC_VER)" \
	"BINUTILS_SRCDIR = ../binutils-$(BINUTILS_VER)" \
	$(if $(GMP_VER),"GMP_SRCDIR = ../gmp-$(GMP_VER)") \
	$(if $(MPC_VER),"MPC_SRCDIR = ../mpc-$(MPC_VER)") \
	$(if $(MPFR_VER),"MPFR_SRCDIR = ../mpfr-$(MPFR_VER)") \
	$(if $(ISL_VER),"ISL_SRCDIR = ../isl-$(ISL_VER)") \
	$(if $(LINUX_VER),"LINUX_SRCDIR = ../linux-$(LINUX_VER)") \
	"-include ../config.mak"

all: | $(SRC_DIRS) $(BUILD_DIR) $(BUILD_DIR)/Makefile $(BUILD_DIR)/config.mak
	cd $(BUILD_DIR) && $(MAKE) $@

install: | $(SRC_DIRS) $(BUILD_DIR) $(BUILD_DIR)/Makefile $(BUILD_DIR)/config.mak
	cd $(BUILD_DIR) && $(MAKE) OUTPUT=$(OUTPUT) $@

endif
=======
	rm -rf $(SOURCES)/config.sub $(SOURCES)/*.tar.bz2

steps/configure_gcc0: steps/install_binutils
steps/configure_gcc: steps/install_musl


$(SOURCES)/config.sub:
	wget -O $@ 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'

$(SOURCES)/binutils-%:
	wget -c -O $@.part http://ftp.gnu.org/pub/gnu/binutils/$(notdir $@)
	mv $@.part $@

$(SOURCES)/gcc-%:
	wget -c -O $@.part http://ftp.gnu.org/pub/gnu/gcc/$(basename $(basename $(notdir $@)))/$(notdir $@)
	mv $@.part $@



steps/extract_binutils: $(SOURCES)/binutils-$(BINUTILS_VER).tar.bz2 $(SOURCES)/config.sub
	tar jxvf $<
	cat patches/binutils-$(BINUTILS_VER)/* | ( cd binutils-$(BINUTILS_VER) && patch -p1 )
	cp $(SOURCES)/config.sub binutils-$(BINUTILS_VER)
	touch $@

steps/configure_binutils: steps/extract_binutils
	test -e binutils-$(BINUTILS_VER)/config.status || ( cd binutils-$(BINUTILS_VER) && ./configure $(BINUTILS_CONFIG) )
	touch $@

steps/build_binutils: steps/configure_binutils
	cd binutils-$(BINUTILS_VER) && $(MAKE)
	touch $@

steps/install_binutils: steps/build_binutils
	cd binutils-$(BINUTILS_VER) && $(MAKE) install
	touch $@




steps/extract_gcc: $(SOURCES)/gcc-$(GCC_VER).tar.bz2 $(SOURCES)/config.sub
	tar jxvf $<
	cat patches/gcc-$(GCC_VER)/* | ( cd gcc-$(GCC_VER) && patch -p1 )
	cp $(SOURCES)/config.sub gcc-$(GCC_VER)
	touch $@

steps/configure_gcc0: steps/extract_gcc
	mkdir -p gcc-$(GCC_VER)/build0
	test -e gcc-$(GCC_VER)/build0/config.status || ( cd gcc-$(GCC_VER)/build0 && ../configure $(GCC0_CONFIG) )
	touch $@

steps/build_gcc0: steps/configure_gcc0
	cd gcc-$(GCC_VER)/build0 && $(MAKE)
	touch $@

steps/configure_gcc: steps/extract_gcc
	mkdir -p gcc-$(GCC_VER)/build
	test -e gcc-$(GCC_VER)/build/config.status || ( cd gcc-$(GCC_VER)/build && ../configure $(GCC_CONFIG) )
	touch $@

steps/build_gcc: steps/configure_gcc
	cd gcc-$(GCC_VER)/build && $(MAKE)
	touch $@

steps/install_gcc: steps/build_gcc
	cd gcc-$(GCC_VER)/build && $(MAKE) -j1 \
		install-gcc \
		install-lto-plugin \
		install-target-libgcc \
		install-target-libssp \
		install-target-libstdc++-v3
	touch $@





steps/clone_musl:
	test -d musl || git clone -b $(MUSL_TAG) git://git.musl-libc.org/musl musl
	touch $@

steps/configure_musl: steps/clone_musl steps/build_gcc0
	cd musl && ./configure $(MUSL_CONFIG)
	cat patches/musl-complex-hack >> musl/config.mak
	touch $@

steps/build_musl: steps/configure_musl
	cd musl && $(MAKE)
	touch $@

steps/install_musl: steps/build_musl
	cd musl && $(MAKE) install DESTDIR=$(OUTPUT)/$(TARGET)
	ln -sfn . $(OUTPUT)/$(TARGET)/usr
	touch $@
>>>>>>> sabotage-linux/support_gcc4
