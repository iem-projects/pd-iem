#!/bin/sh

. ${0%/*}/closet/common

mkdir -p "${BUILDDIR}"
${SCRIPTDIR}/kitchen/ingredients.sh "${OS}"
make -C "${BUILDDIR}" -f "${SCRIPTDIR}/kitchen/cook" DESTDIR="${DESTDIR}/pd-iem" TARGETOS="${OS}" PDDIR="${PDDIR}" PDINCLUDE="${PDDIR}/src" depends
