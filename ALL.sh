#!/bin/sh
ARGS=$@

. ${0%/*}/closet/common

${SCRIPTDIR}/prepare.sh ${ARGS} && \
${SCRIPTDIR}/build.sh   ${ARGS} && \
${SCRIPTDIR}/bundle.sh  ${ARGS}
