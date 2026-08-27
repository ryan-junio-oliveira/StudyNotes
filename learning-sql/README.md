# Curso Completo de SQL — Do Básico ao Avançado

> **Projeto fio-condutor: Catálogo de Filmes.** Todo exemplo usa o mesmo banco `catalogo_filmes`. Você evolui do `CREATE DATABASE` até um sistema real com avaliações, ranking e recomendações — só com SQL.

**Como usar:** leia os capítulos em ordem, execute cada bloco no MySQL 8+ do [`learning-docker`](../learning-docker/) ou PostgreSQL. Ao final, importe [`projeto-catalogo-filmes.sql`](./projeto-catalogo-filmes.sql) e terá o projeto completo executável.

---

## 📚 Sumário do Curso

| # | Capítulo | Conteúdo | Arquivo |
|---|----------|----------|---------|
| 01 | **Introdução** | O que é SQL, categorias DDL/DML/DQL/TCL/DCL, como usar o curso | [01-introducao.md](./01-introducao.md) |
| 02 | **O Projeto: Catálogo de Filmes** | Modelo ER, 8 tabelas, fio-condutor do curso | [02-projeto-catalogo.md](./02-projeto-catalogo.md) |
| 03 | **DDL — Criando Banco e Tabelas** | `CREATE DATABASE`, `CREATE TABLE` completo, `ALTER`/`DROP` | [03-ddl-tabelas.md](./03-ddl-tabelas.md) |
| 04 | **Tipos de Dados e Constraints** | `VARCHAR`, `TEXT`, `DECIMAL`, `YEAR`, `ENUM`, `PK`, `FK`, `CHECK`, `UNIQUE` | [04-tipos-constraints.md](./04-tipos-constraints.md) |
| 05 | **DML — INSERT** | `INSERT` simples, bulk, `SELECT`, `IGNORE`, seed do projeto | [05-dml-insert.md](./05-dml-insert.md) |
| 06 | **DQL — SELECT, WHERE, Ordenação** | `SELECT`, `WHERE`, `BETWEEN`, `LIKE`, `REGEXP`, `ORDER BY`, `LIMIT`, `DISTINCT` | [06-dql-select-where.md](./06-dql-select-where.md) |
| 07 | **Funções e Agregação** | Funções escalares (`CONCAT`, `DATE_FORMAT`, `JSON`), `GROUP BY`, `HAVING` | [07-funcoes-agregacao.md](./07-funcoes-agregacao.md) |
| 08 | **JOINs e Operações de Conjunto** | `INNER`/`LEFT`/`CROSS`/`SELF JOIN`, `UNION`, `INTERSECT`, `EXCEPT` | [08-joins-union.md](./08-joins-union.md) |
| 09 | **Subqueries, CTEs e Window Functions** | Subqueries, `EXISTS`, `WITH`, `RECURSIVE`, `ROW_NUMBER`, `RANK`, `LAG/LEAD` | [09-subqueries-cte-window.md](./09-subqueries-cte-window.md) |
| 10 | **CASE, UPDATE e DELETE** | `CASE`, `COALESCE`, `CAST`, `UPDATE` com `JOIN`, `DELETE`, `TRUNCATE` | [10-case-update-delete.md](./10-case-update-delete.md) |
| 11 | **Índices e Views** | `INDEX`, `FULLTEXT`, `EXPLAIN`, `CREATE VIEW`, `CHECK OPTION` | [11-indices-views.md](./11-indices-views.md) |
| 12 | **Transações, Procedures, Triggers e DCL** | `ACID`, `SAVEPOINT`, `PROCEDURE`, `FUNCTION`, `TRIGGER`, `GRANT`/`REVOKE` | [12-transacoes-procedures-triggers.md](./12-transacoes-procedures-triggers.md) |
| 13 | **Projeto Final — Consultas de Negócio** | Top 5, recomendação por CTE, ranking com window, estatísticas por gênero | [13-projeto-final.md](./13-projeto-final.md) |
| 14 | **Boas Práticas e Apêndice** | 10 boas práticas, exercícios, referência rápida `SHOW`/`DESCRIBE`/`EXPLAIN` | [14-boas-praticas-apendice.md](./14-boas-praticas-apendice.md) |
| 15 | **Normalização** | 1FN/2FN/3FN/BCNF, quando desnormalizar (catálogo) | [15-normalizacao.md](./15-normalizacao.md) |
| 16 | **Agregação Avançada** | `ROLLUP`, `CUBE`, `GROUPING SETS`, `PIVOT`/`UNPIVOT`, `NTILE`, `FIRST/LAST_VALUE` | [16-agregacao-avancada.md](./16-agregacao-avancada.md) |
| 17 | **JSON Avançado** | `JSON_TABLE`, coluna virtual + índice, `JSON_OBJECTAGG` | [17-json-avancado.md](./17-json-avancado.md) |
| 18 | **Particionamento** | `RANGE`/`LIST`/`HASH`, pruning, gerenciamento | [18-particionamento.md](./18-particionamento.md) |
| 19 | **Concorrência e Cursores** | `REPEATABLE READ`, `FOR UPDATE`, deadlocks, `CURSOR`, `HANDLER`, loops | [19-concorrencia-cursores.md](./19-concorrencia-cursores.md) |
| 20 | **Admin, Segurança e Performance** | `mysqldump`, `LOAD DATA`, charset, `information_schema`, injection, `ROLE`, `EXPLAIN ANALYZE`, histogramas | [20-admin-seguranca-performance.md](./20-admin-seguranca-performance.md) |
| 21 | **Comparativo de Dialetos** | MySQL vs PG vs SQL Server vs SQLite — tabela + exemplos por dialeto | [21-dialetos-comparativo.md](./21-dialetos-comparativo.md) |

### 📦 Projeto Executável

| Arquivo | Descrição |
|---------|-----------|
| [`projeto-catalogo-filmes.sql`](./projeto-catalogo-filmes.sql) | DDL + seed + índices + views + procedures + triggers + 8 consultas — `mysql -u root -p < projeto-catalogo-filmes.sql` |

---

## 🗺️ Trilha de Aprendizagem

```
01 Introdução → 02 Projeto (ER do Catálogo)
   ↓
03 DDL → 04 Tipos/Constraints → 05 INSERT → 15 Normalização
   ↓
06 SELECT/WHERE → 07 Funções/Agregação → 16 Agregação Avançada (ROLLUP/PIVOT) → 08 JOINs → 09 Subqueries/CTE/Window
   ↓
10 CASE/UPDATE/DELETE → 11 Índices/Views → 17 JSON → 18 Particionamento
   ↓
12 Transações/Procedures/Triggers → 19 Concorrência/Cursores → 20 Admin/Segurança/Performance → 21 Dialetos
   ↓
13 Projeto Final (6 consultas reais) → 14 Boas Práticas
```

> Cada capítulo reusa os mesmos filmes (`Inception`, `Interstellar`, `Dune`, `Barbie`) e usuários (`Ana`, `Bruno`, `Carla`) — a progressão é cumulativa.

---

## 🚀 Início Rápido

```bash
# Subir MySQL 8 (na raiz do learning-docker)
cd learning-docker && cp .env.example .env && docker-compose up -d

# Importar projeto
mysql -h 127.0.0.1 -P 30000 -u root -p < learning-sql/projeto-catalogo-filmes.sql

# Ou dentro do container
docker-compose exec mysql mysql -u root -p catalogo_filmes < /var/www/projeto-catalogo-filmes.sql
```

Comece por [01. Introdução](./01-introducao.md) →

---

Autor: Ryan Oliveira — Estudo contínuo.
