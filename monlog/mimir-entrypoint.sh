#!/bin/sh
ADVERTISE_ADDR_REPLACE=$(hostname -i | awk '{print $1}')
cp /etc/mimir/mimir.yml /etc/mimir/$(hostname).yml
sed -i "s/ADVERTISE_ADDR_REPLACE/$ADVERTISE_ADDR_REPLACE/" /etc/mimir/$(hostname).yml
exec mimir -config.file=/etc/mimir/$(hostname).yml -config.expand-env=true