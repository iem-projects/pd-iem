#!/bin/sh

. ${0%/*}/closet/common

mkdir -p $(pwd)/build
${SCRIPTDIR}/kitchen/ingredients.sh "${OS}"
make -C build -f "${SCRIPTDIR}/kitchen/cook" DESTDIR="$(pwd)/dist/pd-iem" TARGETOS="${OS}" PDDIR="${PDDIR}" PDINCLUDE="${PDDIR}/src" depends
