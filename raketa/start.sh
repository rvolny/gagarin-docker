#!/bin/bash

# ----------------------------------------------------------------------
# Create the .env file if it does not exist.
# ----------------------------------------------------------------------

if [[ ! -f "/var/www/raketa/.env" ]] && [[ -f "/var/www/raketa/.env.example" ]];
then
    cp /var/www/raketa/.env.example /var/www/raketa/.env
fi

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------

if [[ ! -d "/var/www/raketa/vendor" ]];
then
    cd /var/www/raketa
    composer update
    composer dump-autoload -o
fi

# ----------------------------------------------------------------------
# Start supervisord
# ----------------------------------------------------------------------

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
