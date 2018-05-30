#!/bin/bash
set -e

env >> /var/www/.env
php-fpm7.1 -D
cron
nginx -g "daemon off;"
