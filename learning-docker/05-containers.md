# 05. Containers — Run, Exec, Logs e Inspect (dissecado)

> Parte do [Curso Completo de Docker](./README.md)

## 5.1 `run` — criar e iniciar (flags dissecadas)

```bash
docker container run -d -p 8080:80 --name appNginx nginx
# -d detached (fundo), -p 8080:80 host:container, --name apelido
docker container run -it --rm alpine sh  # -it interativo + tty, --rm apaga ao sair
```

| Flag | O que faz | Se errar |
|------|-----------|----------|
| `-d` | Fundo | Sem `-d`, terminal fica preso |
| `-p 8080:80` | `host:container` | `port is already allocated` → porta 8080 já usada |
| `--name appNginx` | Nome vs hash `5198670617c7` | `Conflict. The container name is already in use` |
| `-v ./apps:/var/www` | Volume bind | Sem `-v`, dado some ao `rm` |
| `--network DokSolutionsNetwork` | Rede | Sem rede, `mysql` não resolve `web` |

## 5.2 Ciclo de vida (mão na massa)

```bash
docker container ls -a          # lista todos (Up / Exited)
docker container run -p 8080:80 nginx  # inicia (baixa se não tem)
# novo terminal
docker container ls             # Up 2 minutes, PORTS 0.0.0.0:8080->80/tcp
curl http://127.0.0.1:8080       # welcome nginx
docker container stop 5198670617c7  # para
docker container rm 5198670617c7    # remove (ou -f força)
docker container rm $(docker container ls -a -q)  # limpa todos parados
```

## 5.3 Logs, exec, stats e inspect (tabela)

| Comando | O que mostra | Quando |
|---------|--------------|--------|
| `docker logs appNginx` / `logs -f` | stdout do container | `nginx` erro 500 |
| `docker exec -it appNginx bash` | Shell dentro | `cat /etc/nginx/nginx.conf` |
| `docker exec appNginx php -v` | Um comando | `php artisan migrate` dentro do `web` |
| `docker stats appNginx` | CPU/RAM ao vivo | Container lento |
| `docker top appNginx` | Processos | Ver `php-fpm` + `nginx` |
| `docker inspect appNginx` | JSON completo (mounts, network) | Debug de volume/rede |
| `docker container prune` | Apaga parados | Limpeza |

**No projeto:** `docker-compose exec web bash` = `docker exec -it web bash` (cap. 07).

---

⬅️ [Anterior: Imagens](./04-imagens.md) | ➡️ [06. Volumes e Networks](./06-volumes-networks.md) | [Sumário](./README.md)
