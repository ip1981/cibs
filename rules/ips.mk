#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license
# at http://www.opensource.org/licenses/CDDL-1.0
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each file.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright (C) 2012, Nexenta Systems, Inc. All rights reserved.
#

# include guard:
ifeq (,$(__ips_mk))

include /usr/share/cibs/rules/common.mk

manifestdir := $(workdir)/manifest
transdir := /usr/share/cibs/trans

ifeq (,$(ips_version))
ips_version = $(version)
endif

# Substitutions in IPS manifest:
# XXX What about to grep all variables from component makefile?
pkg-define = \
-Dsummary="$(summary)" \
-Dlicense="$(license)" \
-Dhome="$(home)" \
-Dname="$(name)" \
-Dversion="$(version)" \
-Dips_version="$(ips_version)" \
-Darchive="$(archive)" \
-Ddownload="$(download)" \
-Dchecksum="$(checksum)" \
 
pkg-define += \
-DMACH="$(mach)" \
-DMACH32="$(mach32)" \
-DMACH64="$(mach64)" \


# Where to find files:
pkg-protos = \
-d "$(destdir)" \
-d "$(sourcedir)" \
-d . \

transformations := \
$(transdir)/defaults \
$(transdir)/actuators \
$(transdir)/devel \
$(transdir)/docs \
$(transdir)/locale \



# Supplied canonical manifests:
manifests := $(wildcard *.p5m)

#TODO: Expand "glob" action in manifests:
globalizator := /usr/share/cibs/scripts/globalizator
glob-manifests := $(manifests:%=$(manifestdir)/glob-%)
$(glob-manifests): $(manifestdir)/glob-% : %
	[ -d "$(manifestdir)" ] || mkdir -p "$(manifestdir)"
	cp $< $@
glob-stamp: $(glob-manifests)
	touch $@


mogrified-manifests := $(manifests:%=$(manifestdir)/mogrified-%)
$(manifestdir)/mogrified-% : $(manifestdir)/glob-%
	pkgmogrify $(pkg-define) \
		$(transformations) \
		$< | \
		sed -e '/^$$/d' -e '/^#.*$$/d' | uniq > $@ || (rm -f $@; false)
mogrify-stamp: $(mogrified-manifests)	
	touch $@


depend-manifests := $(manifests:%=$(manifestdir)/depend-%)
$(manifestdir)/depend-% : $(manifestdir)/mogrified-%
	pkgdepend generate -m $(pkg-protos) $< > $@ || (rm -f $@; false)
depend-stamp: $(depend-manifests)	
	touch $@
$(depend-manifests): install-stamp	

res_suffix := resolved
resolved-manifests := $(manifests:%=$(manifestdir)/depend-%.$(res_suffix))
$(resolved-manifests): $(depend-manifests)	
	pkgdepend resolve -m -s $(res_suffix) $(depend-manifests)
resolve-stamp: $(resolved-manifests)
	touch $@

publish-stamp: resolve-stamp
	pkgsend -s $(ips-repo) publish --fmri-in-manifest \
		$(pkg-protos) \
		$(resolved-manifests)
	touch $@

publish: publish-stamp

__ips_mk := included
endif
