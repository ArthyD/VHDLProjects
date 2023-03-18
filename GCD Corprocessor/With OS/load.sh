#!/bin/sh

/sbin/insmod ./pgcd_coproc.ko $* || exit 1
/sbin/insmod ./axi_btns.ko $* || exit 1

pgcd_coproc_major=`cat /proc/devices | awk "\\$2==\"pgcd_coproc\" {print \\$1}"`
btns_major=`cat /proc/devices | awk "\\$2==\"btns\" {print \\$1}"`


rm -f /dev/pgcd_coproc
mknod /dev/pgcd_coproc c $pgcd_coproc_major 129

rm -f /dev/btns
mknod /dev/btns c $btns_major 129








