# 06. Volumes e Networks

> Parte do [Curso Completo de Docker](./README.md)

## 6.1 Volumes — persistência (dissecado)

| Tipo | Onde fica | Quando usar | Exemplo projeto |
|------|-----------|-------------|-----------------|
| **Named volume** | Gerenciado Docker (`/var/lib/docker/volumes/DOK_SOLUTIONS`) | Banco `mysql` | `DOK_SOLUTIONS:/var/lib/mysql` |
| **Bind mount** | Pasta do host | Código `applications:/var/www` (live reload) | `./applications:/var/www` |
| **Anonymous** | Nome hash | Temp | — |

```bash
docker volume ls && docker volume inspect DOK_SOLUTIONS
docker volume rm DOK_SOLUTIONS  # só se container não usa
docker volume prune             # apaga não usados
```

> **Sem volume, `docker rm mysql` apaga banco!** Com `DOK_SOLUTIONS`, dado persiste.

## 6.2 Networks — containers conversam

```bash
docker network ls
docker network create minha-rede
docker network connect minha-rede web
docker network inspect DokSolutionsNetwork  # vê containers na rede
```

No `docker-compose.yml:12`, `web`, `mysql`, `phpmyadmin`, `rabbitmq` estão em `DokSolutionsNetwork` → `web` acessa `mysql:3306` por nome (DNS interno). Sem rede, seria IP.

---

⬅️ [Anterior: Containers](./05-containers.md) | ➡️ [07. Compose](./07-compose.md) | [Sumário](./README.md)
