# 06. DQL — SELECT, WHERE, Ordenação e Paginação

> Parte do [Curso Completo de SQL](./README.md)

## 6.1 SELECT e Filtros

```sql
-- Básico
SELECT titulo, ano_lancamento FROM filmes;
SELECT * FROM filmes WHERE nota_imdb > 8.6;
SELECT * FROM filmes WHERE ano_lancamento BETWEEN 2010 AND 2020;
SELECT * FROM filmes WHERE diretor_id IN (1,2);
SELECT * FROM filmes WHERE sinopse IS NULL;
SELECT * FROM filmes WHERE titulo LIKE 'Dune%';      -- começa com Dune
SELECT * FROM filmes WHERE titulo LIKE '%stellar%';   -- contém stellar

-- Operadores: =, <>, !=, <, >, <=, >=, AND, OR, NOT
SELECT * FROM filmes
WHERE (nota_imdb >= 8.5 AND duracao_min > 150) OR titulo = 'Inception';

-- IN / NOT IN / BETWEEN / LIKE / REGEXP
SELECT * FROM filmes WHERE titulo REGEXP '^D.*'; -- MySQL regex
```

## 6.2 Ordenação, Paginação e DISTINCT

```sql
SELECT titulo, nota_imdb FROM filmes ORDER BY nota_imdb DESC, ano_lancamento ASC;
SELECT DISTINCT pais FROM diretores;
SELECT titulo FROM filmes LIMIT 2 OFFSET 1; -- paginação: página 2 (2 por página)
-- PG/MySQL 8: SELECT ... OFFSET 1 ROWS FETCH NEXT 2 ROWS ONLY;

-- Top 2 filmes mais bem avaliados
SELECT titulo FROM filmes ORDER BY nota_imdb DESC LIMIT 2;
```

---

⬅️ [Anterior: INSERT](./05-dml-insert.md) | [Próximo: Funções e Agregação](./07-funcoes-agregacao.md) | [Sumário](./README.md)
