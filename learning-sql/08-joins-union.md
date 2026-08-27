# 08. JOINs e Operações de Conjunto

> Parte do [Curso Completo de SQL](./README.md)

## 8.1 JOINs — Relacionamentos

```sql
-- INNER: só com correspondência
SELECT f.titulo, d.nome AS diretor
FROM filmes f
INNER JOIN diretores d ON d.id = f.diretor_id;

-- LEFT JOIN: todos os filmes, mesmo sem diretor
SELECT f.titulo, d.nome AS diretor
FROM filmes f
LEFT JOIN diretores d ON d.id = f.diretor_id;

-- RIGHT JOIN (menos usado) e FULL OUTER (PG: MySQL emula com UNION)
-- CROSS JOIN: produto cartesiano
SELECT * FROM generos CROSS JOIN atores; -- combinações

-- Múltiplos JOINs — filme + diretor + gêneros
SELECT f.titulo, d.nome AS diretor, GROUP_CONCAT(g.nome SEPARATOR ', ') AS generos
FROM filmes f
JOIN diretores d ON d.id = f.diretor_id
JOIN filme_generos fg ON fg.filme_id = f.id
JOIN generos g ON g.id = fg.genero_id
GROUP BY f.id, f.titulo, d.nome;

-- Self JOIN (ex: diretores do mesmo país)
SELECT a.nome, b.nome AS colega_pais
FROM diretores a
JOIN diretores b ON a.pais = b.pais AND a.id < b.id;
```

## 8.2 UNION, INTERSECT e EXCEPT

```sql
-- UNION (remove duplicatas) vs UNION ALL (mantém)
SELECT nome FROM diretores
UNION
SELECT nome FROM atores;

-- Filmes que são Ficção Científica OU têm nota > 8.6
SELECT titulo FROM filmes WHERE id IN (SELECT filme_id FROM filme_generos WHERE genero_id=1)
UNION
SELECT titulo FROM filmes WHERE nota_imdb > 8.6;

-- INTERSECT (PG / MySQL 8.0.31+): filmes que são Ficção E Drama
SELECT filme_id FROM filme_generos WHERE genero_id=1
INTERSECT
SELECT filme_id FROM filme_generos WHERE genero_id=2;

-- EXCEPT (PG) / EXCEPT = filmes de Ficção que não são Ação
-- MySQL: usar NOT IN ou LEFT JOIN ... WHERE IS NULL
SELECT filme_id FROM filme_generos WHERE genero_id=1
EXCEPT
SELECT filme_id FROM filme_generos WHERE genero_id=3;
```

---

⬅️ [Anterior: Funções e Agregação](./07-funcoes-agregacao.md) | [Próximo: Subqueries, CTEs e Window Functions](./09-subqueries-cte-window.md) | [Sumário](./README.md)
