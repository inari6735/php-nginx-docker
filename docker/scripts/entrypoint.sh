set -e

PHP_INI_FILE="/usr/local/etc/php/php.ini-production"
if [ "$APP_MODE" != 'production' ]; then
  PHP_INI_FILE="/usr/local/etc/php/php.ini-development"
fi

ln -sf "$PHP_INI_FILE" "/usr/local/etc/php/php.ini"

exec docker-php-entrypoint "$@"