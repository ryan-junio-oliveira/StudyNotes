# 08. Setup Script — Bootstrap do Blog

> Parte do [Curso Completo de Docker](./README.md)

## 8.1 `setup.sh` dissecado (o que `CMD` executa)

```bash
#!/usr/bin/env bash
set -euo pipefail  # -e exit on error, -u undefined var error, pipefail

APP_DIR="${APP_DIR:-/var/www}"  # 1. Var com default (vem do ARG/Dockerfile)

find "${APP_DIR}" -type d -name "storage" -exec chown -R www-data:www-data {} \; # 2. Permissão Laravel

APP_PATH="${APP_DIR}/Api-User"
if [ -f "${APP_PATH}/composer.json" ]; then  # 3. Só se existe composer.json
  cd "${APP_PATH}"
  composer install --no-dev --optimize-autoloader  # 4. Instala PHP
  if [ -f artisan ]; then
    php artisan key:generate --force || true
    php artisan migrate || true
    php artisan db:seed || true
  fi
fi
# 5. Repete para DokViewerEditor...
mkdir -p /var/www/.../mpdf/tmp && chown -R www-data:www-data ... || true
if [ -d "/var/www/DokViewerGestor..." ]; then chown ...; fi # 6. Guard sambauser
```

| Linha | Por quê | Se não fizer |
|-------|---------|--------------|
| `set -euo pipefail` | Falha rápido se `composer` falhar | Silencia erro, container sobe quebrado |
| `find ... chown` | `storage` precisa ser gravável por `www-data` | `The stream or file ... could not be opened` |
| `|| true` | Não aborta se `artisan` falhar | Sem, `set -e` mata container no primeiro `migrate` falho |

**Quando roda?** `Dockerfile CMD: setup.sh && supervisord` — toda vez que `web` sobe.

---

⬅️ [Anterior: Compose](./07-compose.md) | ➡️ [09. Boas Práticas](./09-boas-praticas.md) | [Sumário](./README.md)
