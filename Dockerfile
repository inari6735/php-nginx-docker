FROM php:8.2-fpm-bullseye AS app_php

# oficjalne obrazy debiana automatycznie usuwają apt cache za pomocą apt-get clean
# https://github.com/moby/moby/blob/03e2923e42446dbb830c654d0eec323a0b4ef02a/contrib/mkimage/debootstrap#L82-L105
RUN apt-get update && apt-get install -y \
    curl \
    ;

WORKDIR /srv/app

# pobranie instalatora rozszerzeń dla PHP - https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions
# pobranie instalatora z oficjalnego obrazu dockera
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# instalacja rozszerzeń
RUN set -eux; \
    install-php-extensions \
      gd \
    ;