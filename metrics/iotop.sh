#!/bin/bash

if [ "$(id -u)" -ne 0 ] ; then
  echo "Must be root" 2>&1
  exit 1
fi

delay=2
lista=$(for p in $(pgrep "."); do echo -n "$p "; grep ^rchar /proc/$p/io 2>/dev/null; done)

while :; do

  echo "-----"
  listb=$(for p in $(pgrep "."); do echo -n "$p "; grep ^rchar /proc/$p/io 2>/dev/null; done)

  echo "$lista" | while read -r pida xa bytesa; do
    [ -e "/proc/$pida" ] || continue
    echo -en "$( ps -p $pida -o comm= ):\t"
    bytesb=$(echo "$listb" | awk -v pid=$pida '$1==pid{print $3}')
    echo "$((($bytesb - $bytesa) / $delay)) b/s"
  done | sort -nk2 | tail
  sleep $delay
  listb=$lista
done

