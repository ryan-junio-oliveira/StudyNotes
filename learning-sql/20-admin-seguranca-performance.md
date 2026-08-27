# 20. Admin, Segurança e Performance

> Parte do [Curso Completo de SQL](./README.md)

## 20.1 Backup, Restore e Import/Export

```bash
# Dump completo (fora do SQL, mas essencial)
mysqldump -u root -p catalogo_filmes > backup.sql
mysql -u root -p catalogo_filmes < backup.sql
# Só estrutura
mysqldump -u root -p --no-data catalogo_filmes > schema.sql
```

```sql
-- LOAD DATA: import CSV 20x mais rápido que INSERT loop
LOAD DATA INFILE '/var/lib/mysql-files/filmes.csv'
INTO TABLE filmes FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- SELECT INTO OUTFILE: export
SELECT * INTO OUTFILE '/var/lib/mysql-files/export.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM filmes;

-- Ver variáveis de import
SHOW VARIABLES LIKE 'secure_file_priv';
```

## 20.2 Charset, Collation, Time Zone e information_schema

```sql
-- Charset/Collation: utf8mb4 suporta emoji
SHOW VARIABLES LIKE 'character_set%';
SHOW COLLATION WHERE Charset='utf8mb4';
-- Criar com collation case-insensitive
CREATE TABLE teste (nome VARCHAR(100) COLLATE utf8mb4_unicode_ci);

-- Time Zone
SELECT @@global.time_zone, @@session.time_zone, NOW(), UTC_TIMESTAMP();
SET time_zone = '-03:00'; -- Brasil

-- information_schema: introspecção
SELECT TABLE_NAME, TABLE_ROWS, DATA_LENGTH FROM information_schema.TABLES WHERE TABLE_SCHEMA='catalogo_filmes';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM information_schema.COLUMNS WHERE TABLE_NAME='filmes';
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_NAME='filmes';
-- PG: pg_catalog, MySQL: SHOW TABLES / DESCRIBE filmes já cobertos no Apêndice
```

## 20.3 Segurança — Injection, Roles e Prepared Statements

```sql
-- ❌ Vulnerável (concatenação)
-- SELECT * FROM usuarios WHERE email = 'ana@email.com' OR '1'='1' -- vaza tudo

-- ✅ Prepared Statement (MySQL)
PREPARE stmt FROM 'SELECT * FROM filmes WHERE titulo = ?';
SET @titulo = 'Inception';
EXECUTE stmt USING @titulo;
DEALLOCATE PREPARE stmt;

-- Roles (MySQL 8)
CREATE ROLE r_leitor, r_editor;
GRANT SELECT ON catalogo_filmes.* TO r_leitor;
GRANT SELECT, INSERT, UPDATE ON catalogo_filmes.* TO r_editor;
CREATE USER 'joao'@'%' IDENTIFIED BY 'senha_forte';
GRANT r_leitor TO 'joao'@'%';
SET DEFAULT ROLE r_leitor TO 'joao'@'%';
SHOW GRANTS FOR 'joao'@'%';

-- Princípio do menor privilégio (ver cap. 12.3 DCL)
```

## 20.4 Performance profunda

```sql
-- EXPLAIN detalhado
EXPLAIN FORMAT=TREE SELECT * FROM filmes WHERE diretor_id=1; -- MySQL 8
EXPLAIN ANALYZE SELECT * FROM filmes JOIN avaliacoes ON avaliacoes.filme_id=filmes.id WHERE filmes.nota_imdb>8; -- tempo real

-- Covering index: índice contém todas as colunas da query (não lê tabela)
CREATE INDEX idx_cover_filmes ON filmes(diretor_id, titulo, nota_imdb);
EXPLAIN SELECT titulo, nota_imdb FROM filmes WHERE diretor_id=1; -- Extra: Using index

-- Histogramas (estatísticas para otimizador)
ANALYZE TABLE filmes UPDATE HISTOGRAM ON nota_imdb WITH 256 BUCKETS;
SELECT HISTOGRAM FROM information_schema.COLUMN_STATISTICS WHERE TABLE_NAME='filmes';

-- Query cache e análise
SHOW PROFILE; -- deprecated, usar performance_schema
SELECT * FROM performance_schema.events_statements_history_long;

-- Dicas de otimização
-- 1. Evite SELECT * + N+1 (prefira JOIN)
-- 2. Paginação com OFFSET grande é lenta → use keyset: WHERE id > ? LIMIT 10
SELECT * FROM filmes WHERE id > 3 ORDER BY id LIMIT 2; -- keyset vs OFFSET 100000
-- 3. LIKE '%termo%' não usa índice → use FULLTEXT (cap. 11)
```

> **Checklist performance:** `EXPLAIN` antes/depois, `ANALYZE TABLE`, índice certo, sem `SELECT *`, sem `OFFSET` gigante.

---

⬅️ [Anterior: Concorrência e Cursores](./19-concorrencia-cursores.md) | [Próximo: Dialetos Comparativo](./21-dialetos-comparativo.md) | [Sumário](./README.md)
