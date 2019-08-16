#!/bin/bash

# ----------------------------------------------------------------------
# Run npm install / build if app is not installed
# ----------------------------------------------------------------------

if [[ ! -d "/var/www/gagarin/node_modules" ]];
then
    cd /var/www/gagarin
    npm install
    npm run build
fi

# ----------------------------------------------------------------------
# Start supervisord
# ----------------------------------------------------------------------

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
