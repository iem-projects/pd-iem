#!/bin/sh

. ${0%/*}/closet/common

${SCRIPTDIR}/prepare.sh -s "${OS}" -p "${PDDIR}" && \
${SCRIPTDIR}/build.sh   -s "${OS}" -p "${PDDIR}" && \
${SCRIPTDIR}/bundle.sh  -s "${OS}" -p "${PDDIR}"
