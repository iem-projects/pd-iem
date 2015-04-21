#!/bin/sh
#
# This script takes a binary file and an optional relative path (with resp. to the file),
# and puts all non-standard dependencies of the binary into that relative path
# and makes the binary use these. 
# originally written by  <hans@at.or.at>
# hacked upon by <zmoelnig@iem.at>
#

error() {
    echo "$@" 1>&2
}
if [ $# -ne 1 ]; then
	error "Usage: $0 <embedpath> <binary>"
	error "  i.e. $0 libs tmp/foo.pd_darwin"
	error "         puts all dependencies of foo.pd_darwin into tmp/libs"
	error "  i.e. $0 "" tmp/libs/libgoo.dylib"
	error "         puts all dependencies into tmp/libs"
	exit 1
fi

RELPATH=$1
shift

count=0
while [ 0 -lt $# ]; do
    bin=$1
    shift
    dir=${bin%/*}/${RELPATH}
    for lib in $(otool -L "${bin}" | sed -e '1d' -e 's|^[^/]*||'  -e 's| .*||' -e '/^\/usr\/lib/d'); do
	install -d "${dir}"
	install -p "${lib}" "${dir}"
	libname=${lib##*/}
	locallib="@loader_path/${RELPATH}/${libname}"
	install_name_tool -id "${locallib}" "${dir}/${libname}"
	install_name_tool -change "${lib}" "${locallib}" "${bin}"
	count=$((count+1))
    done
done

exit ${count}
