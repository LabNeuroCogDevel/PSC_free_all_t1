#!/usr/bin/env bash
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

#
# send to PSC
# 20180709 - init

SCRATCH=/pylon5/ib5fp8p/foranw

rsync -rLzvhi t1s PSC:$SCRATCH --size-only
