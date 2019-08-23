#!/bin/bash

# ----------------------------------------------------------------------
# Create the .env file if it does not exist.
# ----------------------------------------------------------------------

if [[ ! -f "/var/www/raketa/.env" ]] && [[ -f "/var/www/raketa/.env.example" ]];
then
    sudo -u nginx cp /var/www/raketa/.env.example /var/www/raketa/.env
fi

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------

if [[ ! -d "/var/www/raketa/vendor" ]];
then
    cd /var/www/raketa
    sudo -u nginx composer update
    sudo -u nginx composer dump-autoload -o
fi

# ----------------------------------------------------------------------
# Initialize DB if not initialized yet or migrate DB
# ----------------------------------------------------------------------

/wait-for-it.sh -t 0 gagarin-db:$MYSQL_PORT -- echo "Database is up"

if [[ ! -f "/var/www/raketa/.is-initialized" ]];
then
    cd /var/www/raketa

    sudo -u nginx php artisan key:generate && \
    sudo -u nginx php artisan migrate && \
    sudo -u nginx php artisan db:seed && \
    sudo -u nginx php artisan passport:install && \
    sudo -u nginx php artisan storage:link

    sudo -u nginx mkdir /var/www/raketa/storage/app
    sudo -u nginx mkdir /var/www/raketa/storage/app/public
    sudo -u nginx mkdir /var/www/raketa/storage/framework/sessions
    sudo -u nginx mkdir /var/www/raketa/storage/framework/testing
    sudo -u nginx mkdir /var/www/raketa/storage/framework/views
    sudo -u nginx mkdir /var/www/raketa/storage/logs

    sudo -u nginx touch /var/www/raketa/.is-initialized

    echo "Backend initialization completed"
else
    cd /var/www/raketa

    sudo -u nginx php artisan migrate

    echo "Backend migration completed"
fi

# ----------------------------------------------------------------------
# Start supervisord
# ----------------------------------------------------------------------

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
