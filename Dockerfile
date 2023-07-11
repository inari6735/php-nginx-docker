#syntax=docker/dockerfile:1.4

# obraz produkcyjny
FROM php:8.2-fpm-bullseye AS app_php-production

ENV APP_MODE=production

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

COPY --link docker/php/production/php.ini /usr/local/etc/php/php.ini-production
COPY --link docker/php/development/php.ini /usr/local/etc/php/php.ini-development

COPY --link docker/php-fpm/php-fpm.d/process-pool.conf /usr/local/etc/php-fpm.d/process-pool.conf
COPY --link docker/php-fpm/php-fpm.conf /usr/local/etc/php-fpm.conf

COPY --link docker/scripts/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY --link ./application ./

ENTRYPOINT ["docker-entrypoint"]

EXPOSE 9000
CMD ["php-fpm"]

# obraz do developmentu
FROM app_php-production AS app_php-development

ENV APP_MODE=development

FROM nginx:stable-bullseye AS app_nginx

WORKDIR /var/www

COPY --from=app_php-production --link /srv/app/public public/
COPY --link docker/nginx/nginx.conf.template /etc/nginx/templates

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]