# 10. Lab — Stack Completa Mão na Massa

> Parte do [Curso Completo de Docker](./README.md)

## 10.1 Subir do zero

```bash
cd learning-docker
cp .env.example .env  # preencha MYSQL_ROOT_PASSWORD
docker-compose up -d --build
docker-compose ps        # 4 Up (healthy)
docker-compose logs -f web
curl http://localhost:80 # ou :30000 para mysql via DBeaver
docker-compose exec web bash -c "php artisan migrate --help"
```

## 10.2 Ciclo diário

```bash
docker-compose exec web bash
docker-compose logs -f mysql
docker system df && docker image prune
docker-compose down -v --remove-orphans && docker volume prune -f  # limpa tudo (apaga banco!)
```

**Validação:** `DOK_SOLUTIONS` persiste após `down` sem `-v`; com `-v` apaga.

---

⬅️ [Anterior: Boas Práticas](./09-boas-praticas.md) | [Sumário](./README.md)
