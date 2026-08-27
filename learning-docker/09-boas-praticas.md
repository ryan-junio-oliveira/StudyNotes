# 09. Boas Práticas e Segurança

> Parte do [Curso Completo de Docker](./README.md)

## 9.1 Checklist (tabela)

| Prática | Como no projeto | Se não fizer |
|---------|-----------------|--------------|
| **Env vars** `MYSQL_ROOT_PASSWORD=${...}` | `.env.example` + `.gitignore` `.env` | Hardcoded `Admini20m07p` (CVE) |
| **Healthcheck** `mysqladmin ping` / `curl` | `docker-compose.yml:29` + `Dockerfile:151` | Compose sobe `web` antes de `mysql` pronto |
| **.dockerignore** ` .git, .env` | `learning-docker/.dockerignore` | `COPY` leva `.git` (imagem gorda) |
| **Uma `RUN` para `apt-get` + `rm -rf`** | `Dockerfile:17` | Layer com `/var/lib/apt/lists` |
| **Legado opt-in** `INSTALL_LEGACY_RUBY=false` | Evita compilar Ruby 1.9.3 (EOL) | Build 10 min + CVEs |
| **Multi-stage (avançado)** | `FROM php AS builder` + `COPY --from=builder` | Imagem com `build-essential` em produção |

## 9.2 Multi-stage (quando crescer)

```dockerfile
FROM php:8.2-fpm AS builder
RUN composer install --no-dev
FROM php:8.2-fpm
COPY --from=builder /var/www/vendor /var/www/vendor
# Final sem git/build-essential — ~200MB menor
```

---

⬅️ [Anterior: Setup Script](./08-setup-script.md) | ➡️ [10. Lab](./10-lab.md) | [Sumário](./README.md)
