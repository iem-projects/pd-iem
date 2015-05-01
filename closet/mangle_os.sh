#!/bin/sh

OS=$1

case "$1" in
   linux)
   echo "w32"
   ;;
   *)
   echo "$1"
esac
