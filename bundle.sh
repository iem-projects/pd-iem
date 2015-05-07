#!/bin/sh

. ${0%/*}/closet/common

make -C "${BUILDDIR}" -f "${SCRIPTDIR}/kitchen/cook" DESTDIR="${DESTDIR}/pd-iem" TARGETOS="${OS}" PDDIR="${PDDIR}" PDINCLUDE="${PDDIR}/src" install
