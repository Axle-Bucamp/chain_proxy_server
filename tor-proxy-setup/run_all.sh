#!/bin/bash

set -e

mkdir -p /var/lib/tor/tor{1,2,3}

echo "[*] Starting Tor instances..."
for i in 1 2 3; do
    tor -f torrc.d/tor$i.conf &
    sleep 2
done

echo "[*] Starting Privoxy instances..."
for i in 1 2 3; do
    echo $i
    privoxy /etc/privoxy/privoxy.d/config$i &
    sleep 1
done

echo "[✓] All Tor + Privoxy instances running."