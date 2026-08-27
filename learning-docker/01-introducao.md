# 01. Introdução — O que é Docker (começando do zero)

> Parte do [Curso Completo de Docker](./README.md) — Projeto **app-php** (`projeto-app/`)

## 1.1 VM vs Container (analogia)

| VM | Container Docker |
|----|------------------|
| Casa completa (terreno + casa + móveis) — cada VM tem **SO inteiro** | Apartamento (prédio = host, apto = container) — compartilham **kernel** do host |
| Lento para subir (minutos), pesado (GBs) | Sobe em **segundos**, leve (MBs) |
| Isolamento total | Isolamento com cgroups/namespaces |

```
Host (Ubuntu)
 ├─ Container nginx (imagem nginx:alpine) → processo nginx isolado
 ├─ Container php-fpm (imagem php:8.2-fpm) → processo php
 └─ Container mysql (imagem mysql:8) → processo mysqld
Todos no MESMO kernel, mas com filesystem/rede isolados.
```

## 1.2 Imagem vs Container vs Dockerfile

| Termo | Analogia | Exemplo |
|-------|----------|---------|
| **Imagem** | Receita + ingredientes congelados | `php:8.2-fpm` (read-only, camadas) |
| **Container** | Prato servido (instância da imagem) | `web` rodando `php-fpm` + `nginx` |
| **Dockerfile** | Receita escrita | `FROM php:8.2-fpm` + `RUN apt-get...` |
| **Registry** | Supermercado de imagens | Docker Hub (`docker pull nginx`) |

> **Imagem é imutável; container é escrita.**

## 1.3 Daemon e CLI

```bash
docker --version && docker info  # daemon rodando?
docker --help | grep container   # ajuda
```

> Sem daemon rodando → `Cannot connect to the Docker daemon` → `systemctl start docker` (Linux) ou Docker Desktop (Windows).

## 1.4 Glossário mínimo

| Termo | Significado | Exemplo |
|-------|-------------|---------|
| **Layer** | Camada de `RUN`/`COPY` no Dockerfile | Cada `RUN` é uma layer cacheável |
| **Volume** | Pasta persistente fora do container | `DOK_SOLUTIONS:/var/lib/mysql` |
| **Network** | Rede isolada entre containers | `DokSolutionsNetwork` |
| **Compose** | Orquestra múltiplos containers | `docker-compose.yml` |

---

⬅️ [Sumário](./README.md) | ➡️ [02. Projeto App](./02-projeto-app.md)
