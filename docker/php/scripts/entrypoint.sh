#!/bin/sh
set -e

if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

PHP_INI_FILE="/usr/local/etc/php/php.ini-production"
if [ "$APP_MODE" != 'production' ]; then
  PHP_INI_FILE="/usr/local/etc/php/php.ini-development"
fi

ln -sf "$PHP_INI_FILE" "/usr/local/etc/php/php.ini"

exec docker-php-entrypoint "$@"