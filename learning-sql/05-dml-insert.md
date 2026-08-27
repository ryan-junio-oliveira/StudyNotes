# 05. DML — INSERT

> Parte do [Curso Completo de SQL](./README.md)

```sql
-- INSERT simples
INSERT INTO diretores (nome, pais, data_nascimento) VALUES
('Christopher Nolan', 'Reino Unido', '1970-07-30'),
('Denis Villeneuve', 'Canadá', '1967-10-03');

INSERT INTO generos (nome) VALUES ('Ficção Científica'), ('Drama'), ('Ação'), ('Suspense');

INSERT INTO atores (nome) VALUES ('Leonardo DiCaprio'), ('Zendaya'), ('Timothée Chalamet');

-- INSERT com FK
INSERT INTO filmes (titulo, ano_lancamento, duracao_min, nota_imdb, diretor_id, orcamento) VALUES
('Inception', 2010, 148, 8.8, 1, 160000000),
('Dune: Part Two', 2024, 166, 8.5, 2, 190000000),
('Interstellar', 2014, 169, 8.7, 1, 165000000);

-- N:N
INSERT INTO filme_generos VALUES (1,1), (1,4), (2,1), (2,3), (3,1), (3,2);
INSERT INTO filme_atores (filme_id, ator_id, personagem) VALUES
(1, 1, 'Cobb'),
(2, 2, 'Chani'),
(2, 3, 'Paul Atreides');

INSERT INTO usuarios (nome, email) VALUES
('Ana', 'ana@email.com'), ('Bruno', 'bruno@email.com');

INSERT INTO avaliacoes (filme_id, usuario_id, nota, comentario) VALUES
(1, 1, 5, 'Obra-prima!'),
(1, 2, 4, 'Muito bom, complexo'),
(2, 1, 5, 'Visual incrível'),
(3, 2, 5, 'Emocionante');

-- INSERT via SELECT (copiar)
INSERT INTO generos (nome)
SELECT DISTINCT 'Clássico' WHERE NOT EXISTS (SELECT 1 FROM generos WHERE nome='Clássico');

-- INSERT ignorando duplicata
INSERT IGNORE INTO generos (nome) VALUES ('Drama'); -- MySQL
-- PG: INSERT ... ON CONFLICT DO NOTHING
```

> Todos os dados acima são o **seed do projeto** — as próximas consultas dependem deles.

---

⬅️ [Anterior: Tipos e Constraints](./04-tipos-constraints.md) | [Próximo: SELECT e Filtros](./06-dql-select-where.md) | [Sumário](./README.md)
