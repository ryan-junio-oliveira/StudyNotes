# 04. Imagens — Build, Layers e Cache

> Parte do [Curso Completo de Docker](./README.md)

## 4.1 Comandos essenciais (dissecados)

| Comando | O que faz | Se errar |
|---------|-----------|----------|
| `docker image ls` / `docker images` | Lista locais | `REPOSITORY` vazio = `<none>` (dangling) |
| `docker pull nginx:alpine` | Baixa do Hub | `manifest unknown` → tag não existe |
| `docker build -t meu-app .` | Lê `Dockerfile` no `.`  e cria imagem `meu-app` | `failed to compute cache key: not found` → `COPY` além do context |
| `docker push meu-app` | Envia para Hub (precisa `docker login`) | `denied` → sem login ou sem permissão |
| `docker rmi meu-app` | Remove local | `image is being used` → container ainda usa |
| `docker image prune` | Remove `<none>` dangling | `-a` remove todas não usadas (cuidado) |
| `docker system df` / `prune` | Espaço / limpa tudo (containers+networks+images) | `prune` apaga sem perguntar com `-f` |

## 4.2 Layers e cache

```
FROM php:8.2-fpm       ← layer 1 (base)
RUN apt-get ...        ← layer 2 (se mudar esta linha, rebuild daqui pra frente)
COPY ./docker/...      ← layer 3
RUN docker-php-ext...  ← layer 4
```

> Mude ordem: `COPY` que muda muito (app) deixe **por último** para aproveitar cache das layers anteriores.

## 4.3 Build do projeto

```bash
cd learning-docker
docker build -t blog-web .                         # padrão (sem legado)
docker build --build-arg INSTALL_LEGACY_RUBY=true -t blog-web:legacy .
docker build --no-cache -t blog-web .              # ignora cache
```

---

⬅️ [Anterior: Dockerfile](./03-dockerfile.md) | ➡️ [05. Containers](./05-containers.md) | [Sumário](./README.md)
