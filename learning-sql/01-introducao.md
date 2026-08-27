# 01. Introdução — O que é SQL

> Parte do [Curso Completo de SQL](./README.md) — Projeto **Catálogo de Filmes**

SQL (Structured Query Language) é a linguagem padrão para bancos relacionais. Divide-se em:

| Categoria | Sigla | Exemplos |
|-----------|-------|----------|
| Definição | DDL | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| Manipulação | DML | `INSERT`, `UPDATE`, `DELETE` |
| Consulta | DQL | `SELECT` |
| Transação | TCL | `START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` |
| Controle | DCL | `GRANT`, `REVOKE` |

> Este guia foca em **MySQL 8.0** (compatível com o `docker-compose.yml` do projeto). Diferenças para PostgreSQL são sinalizadas com `PG:`.

## Como usar este curso

1. Leia em ordem — cada capítulo usa o mesmo banco `catalogo_filmes`.
2. Execute cada bloco no MySQL 8+ do `learning-docker` (`docker-compose up -d`).
3. Ao final, importe [`projeto-catalogo-filmes.sql`](./projeto-catalogo-filmes.sql) para ter o projeto completo.

---

## Próximo

➡️ [02. O Projeto: Catálogo de Filmes](./02-projeto-catalogo.md)

⬅️ [Voltar ao Sumário](./README.md)
