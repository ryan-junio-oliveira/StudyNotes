# 10. CASE, COALESCE, UPDATE e DELETE

> Parte do [Curso Completo de SQL](./README.md)

## 10.1 CASE, COALESCE e Conversões

```sql
-- CASE: classifica
SELECT titulo, nota_imdb,
    CASE
        WHEN nota_imdb >= 8.8 THEN 'Obra-prima'
        WHEN nota_imdb >= 8.0 THEN 'Excelente'
        WHEN nota_imdb >= 7.0 THEN 'Bom'
        ELSE 'Regular'
    END AS categoria
FROM filmes;

-- COALESCE: trata NULL
SELECT titulo, COALESCE(sinopse, 'Sem sinopse cadastrada') AS sinopse FROM filmes;

-- NULLIF: evita divisão por zero
SELECT titulo, orcamento / NULLIF(duracao_min, 0) AS custo_por_minuto FROM filmes;

-- CAST / CONVERT
SELECT CAST(nota_imdb AS CHAR), CONVERT(orcamento, SIGNED) FROM filmes;
-- PG: nota_imdb::TEXT
```

## 10.2 UPDATE e DELETE

```sql
-- UPDATE sempre com WHERE!
UPDATE filmes SET sinopse = 'Um ladrão que rouba segredos...' WHERE id = 1;
UPDATE filmes SET nota_imdb = nota_imdb + 0.1 WHERE ano_lancamento < 2015;

-- UPDATE com JOIN
UPDATE filmes f
JOIN diretores d ON d.id = f.diretor_id
SET f.sinopse = CONCAT(f.sinopse, ' - Dirigido por ', d.nome)
WHERE f.id = 1;

-- DELETE com WHERE
DELETE FROM avaliacoes WHERE nota < 2;

-- DELETE com JOIN (remover avaliações de filmes antigos)
DELETE a FROM avaliacoes a
JOIN filmes f ON f.id = a.filme_id
WHERE f.ano_lancamento < 2000;

-- TRUNCATE vs DELETE: TRUNCATE é DDL, mais rápido, reseta AUTO_INCREMENT, não dispara triggers
TRUNCATE TABLE avaliacoes;
```

---

⬅️ [Anterior: Subqueries/CTE/Window](./09-subqueries-cte-window.md) | [Próximo: Índices e Views](./11-indices-views.md) | [Sumário](./README.md)
