#!/bin/bash

idx=$1
if [[ "$idx" -lt 1 || "$idx" -gt 3 ]]; then
    echo "Usage: $0 [1-3]"
    exit 1
fi

conf_file=torsocks_$idx.conf
sed "s/__PORT__/910$idx/" torsocks.conf.template > $conf_file
TORSOCKS_CONF_FILE=$conf_file torsocks curl http://ifconfig.me