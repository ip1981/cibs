include /usr/share/cibs/rules/deb.mk
include /usr/share/cibs/rules/git.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk

summary := YAJL is a small event-driven JSON parser written in ANSI C
license := ISC
license-file := COPYING

build-depends += runtime-ruby-18

name     := yajl
home     := http://lloyd.github.com/$(name)/
version  := 2.1.0
git-url  := https://github.com/lloyd/yajl.git
git-checkout := $(version)

configure-options = \
    $(configure-options.$(bits)) \
    --prefix="$(prefix)"

configure-%-stamp: pre-configure-stamp
	cd "$(sourcedir)" && $(configure-env) \
            $(configure) $(configure-options)
	touch $@

build-%-stamp: configure-%-stamp
	cd "$(sourcedir)" && $(MAKE)
	touch $@

install-%-stamp: build-%-stamp
	cd "$(sourcedir)" && $(MAKE) install DESTDIR="$(protodir)"
	touch $@
