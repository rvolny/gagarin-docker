#!/bin/bash

# TODO only run first time - save flag file

cd /var/www/raketa

php artisan key:generate && \
php artisan migrate && \
php artisan db:seed && \
php artisan passport:client --personal && \
php artisan storage:link

mkdir /var/www/raketa/storage/app
mkdir /var/www/raketa/storage/app/public
mkdir /var/www/raketa/storage/framework/sessions
mkdir /var/www/raketa/storage/framework/testing
mkdir /var/www/raketa/storage/framework/views
mkdir /var/www/raketa/storage/logs
