#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/var/www}"

find "${APP_DIR}" -type d -name "storage" -exec chown -R www-data:www-data {} \; 2>/dev/null || true
find "${APP_DIR}" -type d -name "cache" -path "*/bootstrap/cache" -exec chown -R www-data:www-data {} \; 2>/dev/null || true

#############################
# API-USER
#############################
APP_PATH="${APP_DIR}/Api-User"
if [ -f "${APP_PATH}/composer.json" ]; then
  echo "==> Preparando aplicação: ${APP_PATH}"
  cd "${APP_PATH}"

  composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

  if [ -f artisan ]; then
    php artisan key:generate --force || true
    php artisan optimize:clear || true
    php artisan migrate || true
    php artisan db:seed || true
  else
    echo "==> Nenhum artisan encontrado em ${APP_PATH}, pulando comandos Laravel."
  fi
else
  echo "==> composer.json não encontrado em ${APP_PATH}, ignorando."
fi

#############################
# DOKVIEWEREDITOR
#############################
APP_PATH="${APP_DIR}/DokViewerEditorDocumental"
if [ -f "${APP_PATH}/composer.json" ]; then
  echo "==> Preparando aplicação: ${APP_PATH}"
  cd "${APP_PATH}"

  composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

  if [ -f artisan ]; then
    php artisan key:generate --force || true
    php artisan optimize:clear || true
    php artisan migrate || true
    php artisan db:seed || true
  else
    echo "==> Nenhum artisan encontrado em ${APP_PATH}, pulando comandos Laravel."
  fi
else
  echo "==> composer.json não encontrado em ${APP_PATH}, ignorando."
fi

#############################
# DOKVIEWERGESTOR (LEGADO)
#############################
APP_PATH="${APP_DIR}/DokViewerGestorDocumental/public"
if [ -f "${APP_PATH}/composer.json" ]; then
  echo "==> Preparando aplicação: ${APP_PATH}"
  cd "${APP_PATH}"

  composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

else
  echo "==> composer.json não encontrado em ${APP_PATH}, ignorando."
fi

mkdir -p /var/www/dokviewergestordocumental/public/vendor/mpdf/mpdf/tmp/mpdf 2>/dev/null || true
chown -R www-data:www-data /var/www/dokviewergestordocumental/public/vendor/mpdf/mpdf/tmp 2>/dev/null || true

# Configurar permissões para a pasta uplds (só se existir e usuário existir)
if [ -d "/var/www/DokViewerGestorDocumental/public/0/diretorios/uplds" ]; then
  if id sambauser >/dev/null 2>&1; then
    chown -R sambauser:www-data /var/www/DokViewerGestorDocumental/public/0/diretorios/uplds || true
  else
    chown -R www-data:www-data /var/www/DokViewerGestorDocumental/public/0/diretorios/uplds || true
  fi
  chmod -R 775 /var/www/DokViewerGestorDocumental/public/0/diretorios/uplds || true
fi
