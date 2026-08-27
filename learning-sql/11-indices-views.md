# 11. Índices e Views

> Parte do [Curso Completo de SQL](./README.md)

## 11.1 Índices e Performance

```sql
-- Índices aceleram WHERE/JOIN/ORDER BY, mas custam em INSERT/UPDATE
CREATE INDEX idx_filmes_diretor ON filmes(diretor_id);
CREATE INDEX idx_avaliacoes_filme_nota ON avaliacoes(filme_id, nota);
CREATE UNIQUE INDEX idx_generos_nome ON generos(nome);
CREATE FULLTEXT INDEX idx_filmes_sinopse ON filmes(sinopse); -- busca textual

-- Índice composto: ordem importa
CREATE INDEX idx_filmes_ano_nota ON filmes(ano_lancamento, nota_imdb);

-- Ver uso do índice
EXPLAIN SELECT * FROM filmes WHERE diretor_id = 1;
EXPLAIN ANALYZE SELECT * FROM filmes WHERE nota_imdb > 8.5; -- MySQL 8.0.18+

-- Remover índice
DROP INDEX idx_filmes_ano ON filmes;

-- Full-text search
SELECT * FROM filmes WHERE MATCH(sinopse) AGAINST('sonho' IN NATURAL LANGUAGE MODE);
```

**Quando criar índice:** colunas em `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`. Evite em tabelas pequenas ou colunas com baixa cardinalidade.

## 11.2 Views

```sql
-- View: consulta salva como tabela virtual
CREATE VIEW vw_filmes_completos AS
SELECT f.id, f.titulo, f.ano_lancamento, f.nota_imdb, d.nome AS diretor,
       GROUP_CONCAT(g.nome SEPARATOR ', ') AS generos,
       AVG(a.nota) AS media_usuarios, COUNT(a.id) AS total_avaliacoes
FROM filmes f
LEFT JOIN diretores d ON d.id = f.diretor_id
LEFT JOIN filme_generos fg ON fg.filme_id = f.id
LEFT JOIN generos g ON g.id = fg.genero_id
LEFT JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY f.id, f.titulo, f.ano_lancamento, f.nota_imdb, d.nome;

-- Uso
SELECT * FROM vw_filmes_completos WHERE media_usuarios >= 4.5 ORDER BY nota_imdb DESC;

-- View atualizável (simples)
CREATE VIEW vw_filmes_recentes AS
SELECT * FROM filmes WHERE ano_lancamento >= 2020
WITH CHECK OPTION; -- impede inserir filme antigo via view

-- Remover
DROP VIEW IF EXISTS vw_filmes_recentes;
```

---

⬅️ [Anterior: CASE/UPDATE](./10-case-update-delete.md) | [Próximo: Transações, Procedures e Triggers](./12-transacoes-procedures-triggers.md) | [Sumário](./README.md)
