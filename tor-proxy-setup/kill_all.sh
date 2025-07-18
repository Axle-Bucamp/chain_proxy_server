#!/bin/bash

echo "[x] Killing Tor + Privoxy..."
pkill -f "tor -f"
pkill privoxy -f