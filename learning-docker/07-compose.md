# 07. Docker Compose — Orquestra Dissecada

> Parte do [Curso Completo de Docker](./README.md)

## 7.1 `docker-compose.yml` dissecado (web)

```yaml
services:
  web:
    container_name: web
    build:
      context: .              # 1. Pasta do Dockerfile
      dockerfile: ./Dockerfile
      args:                   # 2. ARG do Dockerfile (vem do .env)
        PHP_VERSION: ${PHP_VERSION:-8.2-fpm}
    volumes:
      - ./applications:/var/www              # 3. Bind (código)
      - ./docker/nginx/sites:/etc/nginx/sites-available # 4. Sites
    ports: ["${WEB_HTTP_PORT:-80}:80"]       # 5. Host:Container
    depends_on:               # 6. Ordem + healthcheck
      mysql: { condition: service_healthy }
    healthcheck:              # 7. Compose verifica se web responde
      test: ["CMD-SHELL", "curl -f http://localhost/ || nginx -t"]
```

| Chave | O que faz | Se errar |
|-------|-----------|----------|
| `build.context` | Onde está `Dockerfile` | `failed to read dockerfile` |
| `args` | `--build-arg` via `.env` | Sem `${:-default}`, `PHP_VERSION` vazio → `FROM php:` falha |
| `volumes` | Persiste/compartilha | `./applications` não existe → container vazio |
| `depends_on: condition: service_healthy` | Só sobe `web` se `mysql` healthy | Sem, `web` tenta conectar em `mysql` ainda iniciando → `Connection refused` |
| `healthcheck` | `mysqladmin ping` / `curl` | Sem, Compose considera `started` mesmo com erro |

## 7.2 mysql/phpmyadmin/rabbitmq (referência)

```yaml
  mysql:
    image: mysql:8.0.29-debian
    environment: { MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD} } # nunca hardcoded (cap. 09)
    volumes: [DOK_SOLUTIONS:/var/lib/mysql]
    ports: ["${MYSQL_PORT:-3306}:3306"]
```

## 7.3 Comandos Compose (tabela)

| Comando | Equiv. Docker puro | Quando |
|---------|-------------------|--------|
| `docker-compose up -d --build` | `docker run -d` para cada serviço | Sobe tudo |
| `docker-compose down -v --remove-orphans` | `docker stop` + `rm` + `volume rm` | Limpa tudo |
| `docker-compose logs -f web` | `docker logs -f web` | Ver nginx |
| `docker-compose exec web bash` | `docker exec -it web bash` | Shell no web |
| `docker-compose ps` | `docker ps` | Lista do compose |

> **Compose vs puro:** Compose declara stack em YAML; puro repete `docker run -p -v --network` para cada container.

---

⬅️ [Anterior: Volumes](./06-volumes-networks.md) | ➡️ [08. Setup Script](./08-setup-script.md) | [Sumário](./README.md)
