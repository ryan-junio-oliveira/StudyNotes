# 07. Funções Escalares e Agregação

> Parte do [Curso Completo de SQL](./README.md)

## 7.1 Funções Escalares

```sql
-- String
SELECT UPPER(titulo), LOWER(titulo), LENGTH(titulo), TRIM(titulo) FROM filmes;
SELECT CONCAT(titulo, ' (', ano_lancamento, ')') AS titulo_completo FROM filmes;
SELECT SUBSTRING(titulo, 1, 4), REPLACE(titulo, 'Dune', 'DUNA') FROM filmes;

-- Numéricas
SELECT ROUND(nota_imdb, 1), CEIL(nota_imdb), FLOOR(nota_imdb), MOD(duracao_min, 60) FROM filmes;

-- Data
SELECT YEAR(criado_em), MONTH(criado_em), DATEDIFF(NOW(), data_nascimento) FROM diretores;
SELECT DATE_FORMAT(criado_em, '%d/%m/%Y') FROM filmes; -- MySQL
-- PG: TO_CHAR(criado_em, 'DD/MM/YYYY')
SELECT ADDDATE(NOW(), INTERVAL 30 DAY);

-- JSON (MySQL 8)
-- ALTER TABLE filmes ADD COLUMN metadados JSON;
-- SELECT JSON_EXTRACT(metadados, '$.premios') FROM filmes;
```

## 7.2 Agregação — GROUP BY e HAVING

```sql
-- Contar, média, min/max, soma
SELECT COUNT(*) AS total_filmes, AVG(nota_imdb) AS media_imdb, MAX(duracao_min), MIN(ano_lancamento)
FROM filmes;

-- Filmes por diretor
SELECT d.nome, COUNT(f.id) AS qtd_filmes, AVG(f.nota_imdb) AS media_nota
FROM diretores d
LEFT JOIN filmes f ON f.diretor_id = d.id
GROUP BY d.id, d.nome;

-- Gêneros com mais de 1 filme
SELECT g.nome, COUNT(*) AS total
FROM generos g
JOIN filme_generos fg ON fg.genero_id = g.id
GROUP BY g.nome
HAVING COUNT(*) > 1;

-- Nota média por filme (da tabela avaliacoes)
SELECT f.titulo, COUNT(a.id) AS qtd_avaliacoes, AVG(a.nota) AS media_usuarios, MIN(a.nota), MAX(a.nota)
FROM filmes f
LEFT JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY f.id, f.titulo
HAVING AVG(a.nota) >= 4.5; -- só filmes bem avaliados
```

---

⬅️ [Anterior: SELECT](./06-dql-select-where.md) | [Próximo: JOINs e UNION](./08-joins-union.md) | [Sumário](./README.md)
