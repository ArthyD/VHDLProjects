#!/bin/sh

# invoke rmmod with all arguments we got
/sbin/rmmod pgcd_coproc $* || exit 1
/sbin/rmmod axi_btns   $* || exit 1

# Remove stale nodes
rm -f /dev/pgcd_coproc
rm -f /dev/btns





