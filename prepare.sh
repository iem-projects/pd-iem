#!/bin/sh

error() {
  echo "$@" 1>&2
}
usage() {
 error "usage: $0 [-s <OperatingSystem>] [-p <PdDir>]"
 error "     <OperatingSystem>: either 'osx' or 'w32'"
 error "     <PdDir>: installation path of Pd-Resources"
 error "	default: fetches an separate Pd"
 exit $1
}

SCRIPTDIR=${0%/*}/
cd "${SCRIPTDIR}"
SCRIPTDIR=$(pwd)
cd - >/dev/null

PDDIR=$(pwd)/build/pd
OS=
if [ "x${TRAVIS_OS_NAME}" != "x" ]; then
 OS=$(${SCRIPTDIR}/kitchen/mangle_os.sh ${TRAVIS_OS_NAME})
fi

while getopts "s:p:" opt; do
 case $opt in
   s)
     OS=$OPTARG
     ;;
   p)
     PDDIR=$OPTARG
     ;;
   h|\?)
     usage 0
     ;;
   :)
     error "Option -${OPTARG} requires an argument"
     exit 1
     ;;
   *)
     error "fallback: $OPTARG"
     ;;
  esac
done
shift $(( ${OPTIND} - 1 ))

if [ "x${OS}" = "x" ]; then
  usage 1
fi


mkdir -p $(pwd)/build
${SCRIPTDIR}/kitchen/ingredients.sh "${OS}"
make -C build -f "${SCRIPTDIR}/kitchen/cook" DESTDIR="${SCRIPTDIT}/dist" TARGETOS="${OS}" PDDIR="${PDDIR}" PDINCLUDE="${PDDIR}/src" depends

