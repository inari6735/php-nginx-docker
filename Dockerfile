#syntax=docker/dockerfile:1.4
FROM php:8.2-fpm-bullseye AS app_php

# oficjalne obrazy debiana automatycznie usuwają apt cache za pomocą apt-get clean
# https://github.com/moby/moby/blob/03e2923e42446dbb830c654d0eec323a0b4ef02a/contrib/mkimage/debootstrap#L82-L105
RUN apt-get update && apt-get install -y \
    curl \
    ;

WORKDIR /srv/app

RUN mkdir -p /var/run/php-fpm-sockets

# pobranie instalatora rozszerzeń dla PHP - https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions
# pobranie instalatora z oficjalnego obrazu dockera
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# instalacja rozszerzeń
RUN set -eux; \
    install-php-extensions \
      gd \
    ;

COPY --link docker/php-fpm/php-fpm.d/process-pool.conf /usr/local/etc/php-fpm.d/process-pool.conf
COPY --link docker/php/php.ini /usr/local/etc/php/php.ini
COPY --link docker/php-fpm/php-fpm.conf /usr/local/etc/php-fpm.conf

COPY --link docker/scripts/create-users-and-groups.sh /usr/local/bin/create-users-and-groups
RUN chmod +x /usr/local/bin/create-users-and-groups && create-users-and-groups

CMD ["php-fpm"]