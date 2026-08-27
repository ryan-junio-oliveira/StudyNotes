# 09. Subqueries, CTEs e Window Functions

> Parte do [Curso Completo de SQL](./README.md)

## 9.1 Subqueries e EXISTS

```sql
-- WHERE com subquery
SELECT titulo FROM filmes
WHERE diretor_id = (SELECT id FROM diretores WHERE nome='Christopher Nolan');

-- IN com subquery
SELECT titulo FROM filmes
WHERE id IN (SELECT filme_id FROM avaliacoes WHERE nota = 5);

-- EXISTS (mais eficiente que IN em grandes volumes)
SELECT titulo FROM filmes f
WHERE EXISTS (SELECT 1 FROM avaliacoes a WHERE a.filme_id = f.id AND a.nota = 5);

-- Subquery no FROM (tabela derivada)
SELECT media_por_filme.titulo, media_por_filme.media_nota
FROM (
    SELECT f.titulo, AVG(a.nota) AS media_nota
    FROM filmes f JOIN avaliacoes a ON a.filme_id = f.id
    GROUP BY f.titulo
) AS media_por_filme
WHERE media_nota >= 4.5;

-- Subquery no SELECT (escalar)
SELECT titulo,
       (SELECT AVG(nota) FROM avaliacoes WHERE filme_id = filmes.id) AS media_usuarios
FROM filmes;
```

## 9.2 CTEs — Common Table Expressions

```sql
-- CTE simples: reutiliza cálculo
WITH media_avaliacoes AS (
    SELECT filme_id, AVG(nota) AS media_nota, COUNT(*) AS total
    FROM avaliacoes
    GROUP BY filme_id
)
SELECT f.titulo, m.media_nota, m.total
FROM filmes f
JOIN media_avaliacoes m ON m.filme_id = f.id
WHERE m.media_nota >= 4.5;

-- Múltiplas CTEs
WITH filmes_nolan AS (
    SELECT * FROM filmes WHERE diretor_id = 1
),
stats AS (
    SELECT AVG(nota_imdb) AS media_imdb FROM filmes_nolan
)
SELECT * FROM filmes_nolan, stats;

-- CTE Recursiva: gerar sequência (ex: anos)
WITH RECURSIVE anos AS (
    SELECT 2010 AS ano
    UNION ALL
    SELECT ano + 1 FROM anos WHERE ano < 2024
)
SELECT * FROM anos;
```

## 9.3 Window Functions

```sql
-- Ranking de filmes por nota (sem perder linhas como GROUP BY)
SELECT titulo, nota_imdb,
       ROW_NUMBER() OVER (ORDER BY nota_imdb DESC) AS posicao,
       RANK() OVER (ORDER BY nota_imdb DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY nota_imdb DESC) AS dense_rank
FROM filmes;

-- Partição por diretor: ranking interno
SELECT d.nome AS diretor, f.titulo, f.nota_imdb,
       RANK() OVER (PARTITION BY f.diretor_id ORDER BY f.nota_imdb DESC) AS rank_no_diretor
FROM filmes f JOIN diretores d ON d.id = f.diretor_id;

-- LAG/LEAD: comparar com anterior/próximo
SELECT titulo, ano_lancamento,
       LAG(titulo) OVER (ORDER BY ano_lancamento) AS filme_anterior,
       LEAD(titulo) OVER (ORDER BY ano_lancamento) AS proximo_filme
FROM filmes;

-- Média móvel e acumulado
SELECT titulo, nota_imdb,
       AVG(nota_imdb) OVER (ORDER BY ano_lancamento ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS media_movel,
       SUM(duracao_min) OVER (ORDER BY ano_lancamento) AS duracao_acumulada
FROM filmes;
```

---

⬅️ [Anterior: JOINs](./08-joins-union.md) | [Próximo: CASE, UPDATE e DELETE](./10-case-update-delete.md) | [Sumário](./README.md)
