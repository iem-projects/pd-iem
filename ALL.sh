#!/bin/sh

. ${0%/*}/closet/common

${SCRIPTDIR}/prepare.sh $@ && \
${SCRIPTDIR}/build.sh   $@ && \
${SCRIPTDIR}/bundle.sh  $@
