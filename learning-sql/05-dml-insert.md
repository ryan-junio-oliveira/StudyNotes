# 05. DML — INSERT (sintaxe detalhada)

> Parte do [Curso Completo de SQL](./README.md)
> **DML = Data Manipulation Language** — comandos que **manipulam dados** (não estrutura).

## 5.1 Sintaxe do INSERT — Peça por peça

```sql
INSERT INTO diretores (nome, pais, data_nascimento)  -- 1. Tabela e colunas
VALUES                                               -- 2. Palavra obrigatória
('Christopher Nolan', 'Reino Unido', '1970-07-30'),   -- 3. Linha 1
('Denis Villeneuve', 'Canadá', '1967-10-03');         -- 4. Linha 2 (bulk)
```

| Parte | O que faz | Se errar |
|-------|-----------|----------|
| `INSERT INTO diretores` | Tabela alvo | `Unknown table` se digitar errado |
| `(nome, pais, ...)` | Colunas que vai preencher — ordem importa! | `Column count doesn't match` se faltar/sobrar |
| `VALUES (...)` | Valores na **mesma ordem** das colunas | `'1970-07-30'` em `nome` grava data no nome |
| `, (...)` | Segunda linha = inserção em lote (mais rápido) | Esqueceu `,` → `syntax error` |

> **Dica:** sempre liste colunas `(nome, pais)` — `INSERT INTO diretores VALUES (...)` sem colunas quebra se adicionar coluna depois.

## 5.2 INSERT no catálogo — Teoria vira prática

```sql
-- 1. Tabelas sem FK (pode inserir primeiro)
INSERT INTO diretores (nome, pais, data_nascimento) VALUES
('Christopher Nolan', 'Reino Unido', '1970-07-30'),
('Denis Villeneuve', 'Canadá', '1967-10-03');

INSERT INTO generos (nome) VALUES
('Ficção Científica'), ('Drama'), ('Ação'), ('Suspense');
-- generos.nome é UNIQUE → 'Drama' duplicado ❌ (ver erro abaixo)

INSERT INTO atores (nome) VALUES
('Leonardo DiCaprio'), ('Zendaya'), ('Timothée Chalamet');

-- 2. Tabelas COM FK (precisa que o pai exista)
INSERT INTO filmes (titulo, ano_lancamento, duracao_min, nota_imdb, diretor_id, orcamento) VALUES
('Inception', 2010, 148, 8.8, 1, 160000000),  -- diretor_id=1 existe? Sim → Nolan ✅
('Dune: Part Two', 2024, 166, 8.5, 2, 190000000), -- diretor_id=2 → Villeneuve ✅
('Interstellar', 2014, 169, 8.7, 1, 165000000);   -- diretor_id=99 ❌ falharia (ver erro)

-- 3. N:N (ponte) — só depois de pai existir
INSERT INTO filme_generos VALUES (1,1), (1,4), (2,1), (2,3), (3,1), (3,2);
-- (filme_id=1, genero_id=1) = Inception é Ficção

INSERT INTO filme_atores (filme_id, ator_id, personagem) VALUES
(1, 1, 'Cobb'),           -- Inception + DiCaprio
(2, 2, 'Chani'),          -- Dune + Zendaya
(2, 3, 'Paul Atreides');  -- Dune + Chalamet

-- 4. Restante
INSERT INTO usuarios (nome, email) VALUES
('Ana', 'ana@email.com'), ('Bruno', 'bruno@email.com');
-- email é UNIQUE → 'ana@email.com' duplicado ❌

INSERT INTO avaliacoes (filme_id, usuario_id, nota, comentario) VALUES
(1, 1, 5, 'Obra-prima!'),          -- Ana avaliou Inception ✅
(1, 2, 4, 'Muito bom, complexo'),  -- Bruno avaliou Inception ✅
(2, 1, 5, 'Visual incrível'),
(3, 2, 5, 'Emocionante');
-- (filme_id=1, usuario_id=1) duplicado ❌ UNIQUE par
```

## 5.3 Validações que o banco faz (e as mensagens)

```sql
-- UNIQUE violado
INSERT INTO generos (nome) VALUES ('Drama');
-- ERROR 1062 (23000): Duplicate entry 'Drama' for key 'generos.nome'
-- → Já existe Drama, não pode repetir

-- FOREIGN KEY violado
INSERT INTO filmes (titulo, ano_lancamento, diretor_id) VALUES ('Erro', 2024, 99);
-- ERROR 1452 (23000): Cannot add or update a child row: foreign key fails (`catalogo_filmes`.`filmes`, CONSTRAINT `filmes_ibfk_1` FOREIGN KEY (`diretor_id`) REFERENCES `diretores` (`id`))
-- → Diretor 99 não existe

-- NOT NULL violado
INSERT INTO filmes (titulo) VALUES (NULL);
-- ERROR 1048 (23000): Column 'titulo' cannot be null

-- CHECK violado
INSERT INTO avaliacoes (filme_id, usuario_id, nota) VALUES (1, 3, 10);
-- ERROR 3819 (HY000): Check constraint 'avaliacoes_chk_1' is violated — nota deve ser 1-5

-- UNIQUE composto violado (1 avaliação por usuário/filme)
INSERT INTO avaliacoes (filme_id, usuario_id, nota) VALUES (1, 1, 3);
-- ERROR 1062: Duplicate entry '1-1' for key 'avaliacoes.filme_id' — Ana já avaliou Inception
```

## 5.4 Variações úteis

```sql
-- INSERT via SELECT (copiar dado)
INSERT INTO generos (nome)
SELECT DISTINCT 'Clássico' WHERE NOT EXISTS (SELECT 1 FROM generos WHERE nome='Clássico');
-- Só insere se não existe

-- INSERT ignorando duplicata (MySQL)
INSERT IGNORE INTO generos (nome) VALUES ('Drama'); -- não dá erro, só ignora
-- PG: INSERT INTO generos (nome) VALUES ('Drama') ON CONFLICT (nome) DO NOTHING;

-- INSERT com DEFAULT omitido
INSERT INTO filmes (titulo, ano_lancamento) VALUES ('Sem orçamento', 2024);
-- orcamento vira 0, criado_em vira NOW() — vem do DEFAULT do cap. 04

-- Ver o que inseriu
SELECT LAST_INSERT_ID(); -- id do último AUTO_INCREMENT
SELECT * FROM filmes ORDER BY id DESC LIMIT 3;
```

**Ordem de inserção importa:** pais antes de filhos → `diretores` → `filmes` → `filme_generos`/`avaliacoes`. Inverteu? `ERROR 1452`.

---

⬅️ [Anterior: Tipos e Constraints](./04-tipos-constraints.md) | [Próximo: SELECT e Filtros (dissecado)](./06-dql-select-where.md) | [Sumário](./README.md)
