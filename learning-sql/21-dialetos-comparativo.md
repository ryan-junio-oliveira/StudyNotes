# 21. Comparativo de Dialetos — MySQL vs PostgreSQL vs SQL Server vs SQLite

> Parte do [Curso Completo de SQL](./README.md) — útil para entrevistas e migração

| Recurso | MySQL 8 | PostgreSQL 16 | SQL Server | SQLite |
|---------|---------|---------------|------------|--------|
| **AUTO_INCREMENT** | `INT AUTO_INCREMENT` | `SERIAL` / `GENERATED AS IDENTITY` | `INT IDENTITY(1,1)` | `INTEGER PRIMARY KEY AUTOINCREMENT` |
| **UPSERT** | `ON DUPLICATE KEY UPDATE` | `ON CONFLICT DO NOTHING/UPDATE` | `MERGE` | `ON CONFLICT REPLACE` |
| **LIMIT/OFFSET** | `LIMIT 10 OFFSET 5` | `LIMIT 10 OFFSET 5` / `FETCH NEXT` | `OFFSET 5 ROWS FETCH NEXT 10` | `LIMIT 10 OFFSET 5` |
| **String concat** | `CONCAT(a,b)` | `a \|\| b` | `a + b` / `CONCAT` | `a \|\| b` |
| **Full-text** | `MATCH ... AGAINST` | `to_tsvector` / `GIN` | `CONTAINS` | `FTS5` |
| **JSON** | `JSON_EXTRACT`, `->>` | `jsonb`, `->>` , `GIN` | `JSON_VALUE` | `json_extract` |
| **Window** | Sim (8+) | Sim | Sim | Sim (3.25+) |
| **CTE recursiva** | `WITH RECURSIVE` | `WITH RECURSIVE` | `WITH` | `WITH RECURSIVE` |
| **PIVOT nativo** | Não (emula `CASE`) | `crosstab` (tablefunc) | `PIVOT` | Não |
| **Procedures** | `CREATE PROCEDURE` | `CREATE FUNCTION` / `PROCEDURE` (PG11+) | `CREATE PROCEDURE` | Não |
| **Tipos** | `ENUM`, `YEAR` | `ENUM` custom, `UUID`, `ARRAY`, `hstore` | `UNIQUEIDENTIFIER`, `NVARCHAR` | Tipagem dinâmica |
| **Particionamento** | `RANGE/LIST/HASH` | `Declarative (RANGE/LIST/HASH)` | `Partition function/scheme` | Não |
| **Case sensitive** | Depende collation | Case sensitive | Depende collation | Case insensitive p/ ASCII |

## Exemplos por dialeto — mesma consulta

```sql
-- Top 2 filmes — MySQL / PG
SELECT titulo FROM filmes ORDER BY nota_imdb DESC LIMIT 2;
-- SQL Server
SELECT TOP 2 titulo FROM filmes ORDER BY nota_imdb DESC;
-- Oracle
SELECT titulo FROM filmes ORDER BY nota_imdb DESC FETCH FIRST 2 ROWS ONLY;

-- Concatenar — MySQL
SELECT CONCAT(titulo, ' (', ano_lancamento, ')') FROM filmes;
-- PG / SQLite
SELECT titulo || ' (' || ano_lancamento || ')' FROM filmes;

-- Data atual
-- MySQL: NOW()  PG: NOW()  SQL Server: GETDATE()  SQLite: datetime('now')
```

> **Recomendação:** escreva SQL padrão (ISO) sempre que possível (`LIMIT`, `JOIN`, `CASE`, `WITH`) e isole diferenças de dialeto em camada de repositório. O curso usa MySQL 8 por ser o do `docker-compose.yml`, mas 90% das consultas rodam idênticas em PG.

---

⬅️ [Anterior: Admin e Performance](./20-admin-seguranca-performance.md) | [Sumário](./README.md)
