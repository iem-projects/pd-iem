#!/bin/sh

CC=${CC:-cc}

TEMPDIR=$(mktemp -d $(basename $0).XXXXX )
ORGDIR=$(pwd)
cd "${TEMPDIR}"
cat > conftest.c <<EOF
#include <pthread.h>
int main() { return 0; }
EOF
${CC} conftest.c -lpthread
res=$?

cd "${ORGDIR}"
rm -rf "${TEMPDIR}"

exit ${res}
