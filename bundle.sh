#!/bin/sh

. ${0%/*}/closet/common

make -C build -f "${SCRIPTDIR}/kitchen/cook" DESTDIR="$(pwd)/dist/pd-iem" TARGETOS="${OS}" PDDIR="${PDDIR}" PDINCLUDE="${PDDIR}/src" install
