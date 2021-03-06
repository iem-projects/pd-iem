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
if [ $# -lt 2 ]; then
	error "Usage: $0 <embedpath> <binary> ..."
	error "  i.e. $0 libs tmp/foo.pd_darwin tmp/bar.d_fat"
	error "         puts all dependencies of foo.pd_darwin bar.d_fat into tmp/libs"
	error "  i.e. $0 "" tmp/libs/libgoo.dylib"
	error "         puts all dependencies into tmp/libs"
	exit 0
fi

RELPATH=$1
shift

count=0
while [ 0 -lt $# ]; do
    bin=$1
    shift
    dir=${bin%/*}/${RELPATH}
    for lib in $(otool -L "${bin}" | sed -e '1d' -e '/@/d' -e 's|^[ 	]*||'  -e 's| .*||' -e '/^\/usr\/lib/d'); do
	#error "lib[${bin}]: ${lib}"
	libname=${lib##*/}
	locallib="@loader_path/${RELPATH}/${libname}"
	if [ -e "${lib}" ]; then
	 if [ -e "${dir}/${libname}" ]; then
	  error "skipping local copy of already existing library ${lib}"
         else
	  install -d "${dir}"
	  install -p "${lib}" "${dir}"
          error "installed '${lib}' in '${dir}': ${locallib}"
         fi
	 install_name_tool -id "${locallib}" "${dir}/${libname}"
	 install_name_tool -change "${lib}" "${locallib}" "${bin}"
	 count=$((count+1))
	else
	 error "skipping non-existant dependency ${lib}"
	fi
    done
done

exit ${count}
