#!/bin/bash
# Check if AC is connected (1=connected, 0=disconnected)
AC_ONLINE=$(cat /sys/class/power_supply/AC/online)
if [ "$AC_ONLINE" = "1" ]; then
    # When charging, set fan to higher speed
    /usr/bin/nbfc set -s 80 -f 0
    echo "AC connected: Setting fan to high speed (80%)"
else
    # When on battery, use automatic control
    /usr/bin/nbfc set -a
    echo "On battery: Setting fan to automatic control"
fi
