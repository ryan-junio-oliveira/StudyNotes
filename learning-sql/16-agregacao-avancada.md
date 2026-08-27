# 16. Agregação Avançada — ROLLUP, CUBE, GROUPING SETS e PIVOT

> Parte do [Curso Completo de SQL](./README.md)

## 16.1 ROLLUP — Subtotais hierárquicos

```sql
-- Total por diretor + total geral (NULL = subtotal)
SELECT d.nome AS diretor, g.nome AS genero, COUNT(*) AS filmes
FROM filmes f
JOIN diretores d ON d.id = f.diretor_id
JOIN filme_generos fg ON fg.filme_id = f.id
JOIN generos g ON g.id = fg.genero_id
GROUP BY d.nome, g.nome WITH ROLLUP;
-- Linha com d.nome=NULL, g.nome=NULL = total geral
-- Linha com g.nome=NULL = subtotal por diretor

-- Identificar nível do subtotal
SELECT d.nome, g.nome, COUNT(*) AS filmes,
       GROUPING(d.nome) AS is_total_diretor, GROUPING(g.nome) AS is_total_genero
FROM filmes f
JOIN diretores d ON d.id = f.diretor_id
JOIN filme_generos fg ON fg.filme_id = f.id
JOIN generos g ON g.id = fg.genero_id
GROUP BY d.nome, g.nome WITH ROLLUP;
```

## 16.2 CUBE — Todas as combinações (MySQL 8+ via UNION)

```sql
-- MySQL não tem CUBE nativo; emula com UNION + GROUPING SETS
-- PG: GROUP BY CUBE(d.nome, g.nome)

-- GROUPING SETS: escolhe quais agregações
SELECT d.nome AS diretor, g.nome AS genero, COUNT(*) AS filmes
FROM filmes f
JOIN diretores d ON d.id = f.diretor_id
JOIN filme_generos fg ON fg.filme_id = f.id
JOIN generos g ON g.id = fg.genero_id
GROUP BY GROUPING SETS ((d.nome, g.nome), (d.nome), (g.nome), ());
-- 4 consultas em 1: por (diretor,gênero), só diretor, só gênero, total
```

## 16.3 PIVOT — Linhas viram colunas

MySQL não tem `PIVOT` nativo — faz com `CASE` + agregação:

```sql
-- PIVOT: quantos filmes de cada gênero por diretor (gêneros viram colunas)
SELECT d.nome AS diretor,
       SUM(CASE WHEN g.nome='Ficção Científica' THEN 1 ELSE 0 END) AS ficcao,
       SUM(CASE WHEN g.nome='Ação' THEN 1 ELSE 0 END) AS acao,
       SUM(CASE WHEN g.nome='Drama' THEN 1 ELSE 0 END) AS drama,
       COUNT(*) AS total
FROM diretores d
LEFT JOIN filmes f ON f.diretor_id = d.id
LEFT JOIN filme_generos fg ON fg.filme_id = f.id
LEFT JOIN generos g ON g.id = fg.genero_id
GROUP BY d.nome;

-- UNPIVOT (colunas viram linhas) — via UNION ALL
SELECT titulo, 'nota_imdb' AS metrica, CAST(nota_imdb AS CHAR) AS valor FROM filmes
UNION ALL
SELECT titulo, 'duracao_min', CAST(duracao_min AS CHAR) FROM filmes;
```

## 16.4 Window Functions avançadas (complemento ao cap. 09)

```sql
-- NTILE: divide em N baldes (quartis)
SELECT titulo, nota_imdb, NTILE(4) OVER (ORDER BY nota_imdb DESC) AS quartil
FROM filmes;

-- FIRST_VALUE / LAST_VALUE / NTH_VALUE
SELECT titulo, nota_imdb,
       FIRST_VALUE(titulo) OVER (ORDER BY nota_imdb DESC) AS melhor_filme,
       LAST_VALUE(titulo) OVER (ORDER BY nota_imdb DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS pior_filme,
       NTH_VALUE(titulo, 2) OVER (ORDER BY nota_imdb DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS segundo_melhor
FROM filmes;

-- Frame: média móvel de 3 filmes
SELECT titulo, nota_imdb,
       AVG(nota_imdb) OVER (ORDER BY ano_lancamento ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS media_movel_3
FROM filmes;

-- Percentil
SELECT titulo, nota_imdb,
       PERCENT_RANK() OVER (ORDER BY nota_imdb) AS percent_rank,
       CUME_DIST() OVER (ORDER BY nota_imdb) AS cume_dist
FROM filmes;
```

---

⬅️ [Anterior: Normalização](./15-normalizacao.md) | [Próximo: JSON](./17-json-avancado.md) | [Sumário](./README.md)
