#!/bin/bash

# Przerwanie wykonania skryptu po pierwszym napotkanym błędzie
set -e

# Sprawdzenie, czy skrypt jest uruchomiony z uprawnieniami roota
if [[ $EUID -ne 0 ]]; then
   echo "Ten skrypt musi być uruchomiony z uprawnieniami administratora (root)."
   exit 1
fi

APP_USER="app_user"
APP_GROUP="app_group"

NGINX_USER="nginx_user"
NGINX_GROUP="nginx_group"

groupadd --gid 1001 "$APP_GROUP"
groupadd --gid 1002 "$NGINX_GROUP"

useradd --uid 1001 "$APP_USER"
useradd --uid 1002 "$NGINX_USER"