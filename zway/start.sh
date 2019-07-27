#! /bin/bash

#chown root:root /dev/ttyAMA0
#/etc/init.d/z-way-server start
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

mount -o remount,rw /
systemctl mask serial-getty@ttyAMA0.service
systemctl mask serial-getty@serial0.service
systemctl mask serial-getty@serial1.service
systemctl disable hciuart
stty -F /dev/ttyAMA0 9600
echo "zway config done"

while true; do
    sleep 120
done