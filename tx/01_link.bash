#!/usr/bin/env bash
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

#
# link things so we can tx with one rsync
# 20180709 - init
#

cd $(dirname $0)

[ ! -d t1s ] && mkdir t1s
sed '1d;s/"//g; /NA$/d' allT1s.txt | while read rowid id dir; do
   [ ! -r $dir ] && echo "$id: cannot read $dir" && continue
   ln -s $dir t1s/$id
done


