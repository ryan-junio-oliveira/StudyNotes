# Curso Completo de Docker — Do Zero ao Stack PHP

> **Projeto fio-condutor: App PHP (Laravel Blog) com `web` + `mysql` + `phpmyadmin` + `rabbitmq`** via `docker-compose.yml`. De `docker run nginx` até stack com `healthcheck` + `setup.sh`.

---

## 📚 Sumário

| # | Capítulo | Conteúdo | Arquivo |
|---|----------|----------|---------|
| 01 | **Introdução** | VM vs container, imagem vs container vs Dockerfile, daemon, glossário | [01-introducao.md](./01-introducao.md) |
| 02 | **Projeto App** | Stack `web/mysql/rabbitmq` + portas + rede `DokSolutionsNetwork` | [02-projeto-app.md](./02-projeto-app.md) |
| 03 | **Dockerfile** | `FROM`/`ARG`, `RUN` layers, `COPY`, `HEALTHCHECK`, `CMD supervisord` dissecado | [03-dockerfile.md](./03-dockerfile.md) |
| 04 | **Imagens** | `build`/`pull`/`push`/`rmi`/`prune`, layers e cache | [04-imagens.md](./04-imagens.md) |
| 05 | **Containers** | `run -d -p --name`, `ls`/`stop`/`rm`, `logs -f`/`exec -it`/`stats`/`inspect` | [05-containers.md](./05-containers.md) |
| 06 | **Volumes e Networks** | Named vs bind, `DOK_SOLUTIONS`, `DokSolutionsNetwork` | [06-volumes-networks.md](./06-volumes-networks.md) |
| 07 | **Compose** | `docker-compose.yml` dissecado + `healthcheck` + `depends_on` + `up` vs `run` | [07-compose.md](./07-compose.md) |
| 08 | **Setup Script** | `setup.sh` dissecado (`composer install`, `migrate`, `chown` + `|| true`) | [08-setup-script.md](./08-setup-script.md) |
| 09 | **Boas Práticas** | Env vars, healthcheck, `.dockerignore`, legado opt-in, multi-stage | [09-boas-praticas.md](./09-boas-praticas.md) |
| 10 | **Lab** | `cp .env.example .env && docker-compose up -d --build` + ciclo diário | [10-lab.md](./10-lab.md) |

### 📦 Referências (arquivos reais do stack)

| Arquivo | Papel |
|---------|-------|
| [`Dockerfile`](./Dockerfile) | Receita `web` (PHP 8.2 + nginx + supervisor) — cap. 03 |
| [`docker-compose.yml`](./docker-compose.yml) | Orquestra `web`/`mysql`/`rabbitmq` — cap. 07 |
| [`setup.sh`](./setup.sh) | Bootstrap Laravel (`composer`/`migrate`) — cap. 08 |
| [`docker/nginx/nginx.conf`](./docker/nginx/nginx.conf) | Nginx — cap. 03 |
| [`projeto-app/index.php`](./projeto-app/index.php) | Playground minimal |

---

## 🗺️ Trilha

```
01 Intro (VM vs container)
   ↓
02 Projeto (stack web/mysql/rabbitmq)
   ↓
03 Dockerfile → 04 Imagens → 05 Containers → 06 Volumes/Networks
   ↓
07 Compose → 08 setup.sh → 09 Boas práticas → 10 Lab (up -d --build)
```

Comece por [01. Introdução](./01-introducao.md) →
