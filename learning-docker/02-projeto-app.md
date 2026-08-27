# 02. O Projeto: App PHP + Nginx + MySQL + RabbitMQ

> Parte do [Curso Completo de Docker](./README.md)

## 2.1 Stack fio-condutor (blog Laravel + SQL `catalogo_filmes`)

```
web (php:8.2-fpm + nginx + supervisor) ──► mysql:8.0 (DOK_SOLUTIONS)
  ├─ porta 80/443 (app)                    ├─ porta 30000:3306
  ├─ phpMyAdmin :8080 ──► mysql
  └─ rabbitmq:5672/15672
        via DokSolutionsNetwork
```

| Serviço | Imagem | Porta host→container | Papel |
|---------|--------|----------------------|-------|
| `web` | `build: Dockerfile` | `80:80, 443:443` | PHP + Nginx (app Laravel/Blog) |
| `mysql` | `mysql:8.0.29-debian` | `30000:3306` | Banco `catalogo_filmes`/`blog` |
| `phpmyadmin` | `phpmyadmin:latest` | `8080:80` | Admin MySQL |
| `rabbitmq` | `rabbitmq:3.13-management` | `5672:5672, 15672:15672` | Fila (cap. 21 Laravel) |

> **Mesmo domínio** dos cursos SQL/Laravel: `blog` roda no `web` + `mysql`.

## 2.2 Estrutura do repo

```
learning-docker/
 ├─ Dockerfile                 ← receita do web (cap. 03)
 ├─ docker-compose.yml         ← orquestra web+mysql+rabbitmq (cap. 07)
 ├─ setup.sh                  ← bootstrap Laravel no web (cap. 08)
 ├─ .env.example              ← segredos (cap. 09)
 ├─ docker/nginx/nginx.conf   ← nginx (cap. 03)
 ├─ docker/supervisord/       ← supervisord (nginx+php-fpm)
 └─ projeto-app/              ← playground (index.php minimal)
```

## 2.3 Fluxo do curso

```
03 Dockerfile (receita web) → 04 Imagens (build) → 05 Containers (run/exec/logs)
 → 06 Volumes/Networks → 07 Compose → 08 setup.sh → 09 Boas práticas → 10 Lab
```

---

⬅️ [Anterior: Introdução](./01-introducao.md) | ➡️ [03. Dockerfile](./03-dockerfile.md) | [Sumário](./README.md)
