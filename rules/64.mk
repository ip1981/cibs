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

ifeq (,$(__64_mk))

include $(cibs-root)/rules/common.mk

$(eval $(call add-variant,64))

%-64-stamp: bits = 64

# build64 = \#, now it is emtpy and lines like
# $(build64) file path=...
# in manifests are included
build64 :=
__64_mk := included

endif
