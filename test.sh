#!/bin/bash

idx=$(( (RANDOM % 3) + 1 ))
echo "Using proxy 811$idx (Tor $idx)"
curl --proxy http://127.0.0.1:811$idx http://ifconfig.me