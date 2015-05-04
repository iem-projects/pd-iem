#!/bin/sh

CC=${CC:-cc}

TEMPDIR=$(mktemp -d)
cd "${TEMPDIR}"
cat > conftest.c <<EOF
#include <pthread.h>
int main() { return 0; }
EOF
${CC} conftest.c -lpthread
res=$?
rm -rf "${TEMPDIR}"

exit ${res}
