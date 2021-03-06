#!/bin/sh

error() {
  echo "$@" 1>&2
}

if [ $# -ne 1 ]; then
	error "Usage: $0 external/dir/"
	error "  i.e. $0 iemmatrix/"
	exit
fi

MAXITERATIONS=10
DIR=$1

## iteration 0 (get direct dependencies)
find "${DIR}" -type f -iname "*.dll" -print0 | xargs -0 ${0%/*}/pastyroll-w32.sh libs
RES=$?

count=0

# iterate to resolve dependencies of dependencies
while test 0 -lt ${RES}; do
    error "########################## iteration ${count} ##################"
    find "${DIR}" -type f -iname "*.dll" -print0 | xargs -0 ${0%/*}/pastyroll-w32.sh ''
    RES=$?
    if [ ${count} -gt ${MAXITERATIONS} ]; then
      RES=0
    fi
    count=$((count+1))
done

find "${DIR}" -type f -iname "*.dll" -size 0 -delete
find "${DIR}" -type f -iname "*.dll" -exec i686-w64-mingw32-strip --strip-unneeded \{\} \;
