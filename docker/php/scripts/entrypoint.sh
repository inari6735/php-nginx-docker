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

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ]; then
  if [ ! -f composer.json ]; then
    composer init --name="php-nginx-docker" --autoload --prefer-dist --no-progress --no-interaction
    composer require "php:>=$PHP_VERSION"
  fi

  if [ "$APP_MODE" != 'production' ]; then
    composer install --prefer-dist --no-progress --no-interaction
  fi
fi

exec docker-php-entrypoint "$@"