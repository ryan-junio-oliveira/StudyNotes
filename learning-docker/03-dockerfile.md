# 03. Dockerfile — Receita Dissecada

> Parte do [Curso Completo de Docker](./README.md)

## 3.1 `FROM` + `ARG` (base + parâmetros)

```dockerfile
ARG PHP_VERSION=8.2-fpm   # 1. Parâmetro com default (sobrescreve: --build-arg PHP_VERSION=8.3-fpm)
FROM php:${PHP_VERSION}   # 2. Imagem base (deve vir após ARG)
ARG APP_DIR=/var/www      # 3. Usado em WORKDIR/COPY
```

## 3.2 `RUN` — camadas (dissecado)

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx supervisor curl git ... \
    && rm -rf /var/lib/apt/lists/*  # 4. Limpa cache na MESMA layer (senão layer fica gorda)
```

| Boas práticas | Por quê | Se não fizer |
|---------------|---------|--------------|
| `&& rm -rf /var/lib/apt/lists/*` na mesma `RUN` | Não cria layer com cache | Imagem +200MB |
| `--no-install-recommends` | Só essenciais | Instala docs extras |
| Uma `RUN` para `apt-get` (não 3) | Cache eficiente | 3 layers = rebuild lento |

**Ghostscript e Ruby legados** são condicionais (`INSTALL_GHOSTSCRIPT_SRC=false` por padrão) — evita compilar `ghostscript-9.54.0.tar.gz` e `rbenv 1.9.3` (EOL) se não precisa (cap. 09).

## 3.3 `COPY` e `WORKDIR`

```dockerfile
WORKDIR ${APP_DIR}  # cd /var/www (cria se não existe)
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf  # 5. Copia do host → imagem
COPY ./applications* ${APP_DIR}/  # 6. * evita quebrar se pasta vazia
```

> **Erro:** `COPY failed: file not found` → pasta não existe no `context: .` (ver `docker-compose.yml:6`).

## 3.4 `RUN` PHP extensions + `HEALTHCHECK` + `CMD`

```dockerfile
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql ... # 7. Compila extensões PHP

HEALTHCHECK --interval=30s CMD curl -f http://localhost/ || exit 1 # 8. Docker verifica se nginx responde

CMD ["/bin/bash", "-c", "/usr/local/bin/setup.sh && exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
# 9. setup.sh (cap. 08) prepara Laravel, depois supervisord sobe nginx+php-fpm
```

**Ordem importa:** `FROM` → `RUN apt` → `COPY nginx` → `RUN php-ext` → `WORKDIR` → `HEALTHCHECK` → `CMD`.

---

⬅️ [Anterior: Projeto App](./02-projeto-app.md) | ➡️ [04. Imagens](./04-imagens.md) | [Sumário](./README.md)
