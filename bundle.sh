#!/bin/sh

. ${0%/*}/closet/common

${SCRIPTDIR}/../closet/readme.sh $@ > "${DESTDIR}/pd-iem/README.txt"
make -C "${BUILDDIR}" -f "${SCRIPTDIR}/kitchen/cook" DESTDIR="${DESTDIR}/pd-iem" TARGETOS="${OS}" PDDIR="${PDDIR}" PDINCLUDE="${PDDIR}/src" install
