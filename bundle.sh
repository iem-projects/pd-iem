#!/bin/sh
ARGS=$@

. ${0%/*}/closet/common

mkdir -p "${DESTDIR}/pd-iem/"
${SCRIPTDIR}/closet/readme.sh ${ARGS} > "${DESTDIR}/pd-iem/README.txt"
make -C "${BUILDDIR}" -f "${SCRIPTDIR}/kitchen/cook" \
	DESTDIR="${DESTDIR}/pd-iem" \
	TARGETOS="${OS}" \
	PDDIR="${PDDIR}" \
	PDINCLUDE="${PDDIR}/src" \
	RECIPES="${RECIPES}" \
	install
