#!/bin/bash

for port in 9201 9202 9203; do
  echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc 127.0.0.1 $port > /dev/null
done

echo "[✓] New Tor circuits requested."
