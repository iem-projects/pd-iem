#!/bin/sh

if [ $# -ne 1 ]; then
	error "Usage: $0 external/dir/"
	error "  i.e. $0 iemmatrix/"
	exit
fi

MAXITERATIONS=10
DIR=$1

find "${DIR}" -type f -name "*.dll" -print0 | xargs -0 ${0%/*}/pastyroll-w32.sh libs
RES=$?

count=0
while test 0 -lt ${RES}; do
    error "########################## iteration ${count} ##################"
    find "${DIR}" -type f -print0 | xargs -0 ${0%/*}/pastyroll-w32.sh ''
    RES=$?
    if [ ${count} -gt ${MAXITERATIONS} ]; then
      RES=0
    fi
    count=$((count+1))
done
