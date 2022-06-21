#!/bin/sh

sed "s/\${INFLUXDB_ADMIN_TOKEN}/$(printf '%s\n' "$INFLUXDB_ADMIN_TOKEN" | sed -e 's/[\/&]/\\&/g')/" < /templates/influxdb.cfg.template > "$OPENHAB_CONF/services/influxdb.cfg"
