# 06. DQL — SELECT, WHERE, Ordenação e Paginação (dissecado)

> Parte do [Curso Completo de SQL](./README.md)
> **DQL = Data Query Language** — o mais usado. **SELECT lê dados sem alterar nada.**

## 6.1 Sintaxe do SELECT — Peça por peça

```sql
SELECT titulo, ano_lancamento  -- 1. Colunas que quer ver (ou * para todas)
FROM filmes                    -- 2. Tabela de onde vem
WHERE nota_imdb > 8.6          -- 3. Filtro (opcional)
ORDER BY nota_imdb DESC        -- 4. Ordenação (opcional)
LIMIT 2;                       -- 5. Quantos trazer (opcional)
```

| Cláusula | O que faz | Se omitir |
|----------|-----------|-----------|
| `SELECT titulo, ano` | Escolhe colunas | `SELECT *` traz todas (evite em produção — lento) |
| `FROM filmes` | Tabela fonte | Obrigatório |
| `WHERE ...` | Filtra linhas | Traz tudo |
| `ORDER BY ...` | Ordena | Ordem aleatória |
| `LIMIT/OFFSET` | Pagina | Traz tudo |

**Ordem importa:** `SELECT → FROM → WHERE → ORDER BY → LIMIT` — inverter dá `syntax error`.

## 6.2 WHERE — Filtros na prática (catálogo)

```sql
-- Comparação simples
SELECT * FROM filmes WHERE nota_imdb > 8.6;  -- maior que 8.6
SELECT * FROM filmes WHERE ano_lancamento = 2010; -- igual
SELECT * FROM filmes WHERE titulo <> 'Inception'; -- diferente (<> ou !=)

-- BETWEEN (inclusive)
SELECT * FROM filmes WHERE ano_lancamento BETWEEN 2010 AND 2020; -- 2010, 2014, etc

-- IN (lista)
SELECT * FROM filmes WHERE diretor_id IN (1,2); -- Nolan ou Villeneuve
SELECT * FROM filmes WHERE diretor_id NOT IN (1); -- não é Nolan

-- NULL (armadilha!)
SELECT * FROM filmes WHERE sinopse IS NULL;     -- ✅ correto
SELECT * FROM filmes WHERE sinopse = NULL;      -- ❌ sempre 0 linhas (NULL não é =)
SELECT * FROM filmes WHERE sinopse IS NOT NULL; -- com sinopse

-- LIKE (padrão com % e _)
SELECT * FROM filmes WHERE titulo LIKE 'Dune%';    -- começa com Dune → Dune 1, Dune 2
SELECT * FROM filmes WHERE titulo LIKE '%stellar%'; -- contém stellar → Interstellar
SELECT * FROM filmes WHERE titulo LIKE 'Dun_';      -- Dun + 1 char → Dune

-- REGEXP (MySQL)
SELECT * FROM filmes WHERE titulo REGEXP '^D.*'; -- começa com D

-- Lógica composta
SELECT * FROM filmes
WHERE (nota_imdb >= 8.5 AND duracao_min > 150) -- nota alta E longo
   OR titulo = 'Inception';                      -- OU é Inception

-- Prioridade: AND antes de OR — use () para garantir
WHERE nota_imdb > 8 AND ano_lancamento > 2020 OR titulo='Inception'
-- É (nota>8 AND ano>2020) OR titulo — não nota>8 AND (ano>2020 OR titulo)
```

**Tabela de operadores:**

| Operador | Significado | Exemplo |
|----------|-------------|---------|
| `=` | igual | `ano_lancamento = 2010` |
| `<>` ou `!=` | diferente | `titulo <> 'Inception'` |
| `< > <= >=` | comparação | `nota_imdb >= 8.5` |
| `BETWEEN a AND b` | entre (inclusive) | `ano BETWEEN 2010 AND 2020` |
| `IN (1,2)` | dentro da lista | `diretor_id IN (1,2)` |
| `LIKE 'D%'` | padrão | `'Dune%'` |
| `IS NULL` | é nulo | `sinopse IS NULL` |
| `AND OR NOT` | lógica | `nota>8 AND duracao>150` |

## 6.3 Ordenação, Paginação e DISTINCT

```sql
-- ORDER BY: ordena (ASC = crescente padrão, DESC = decrescente)
SELECT titulo, nota_imdb FROM filmes ORDER BY nota_imdb DESC; -- maior nota primeiro
SELECT titulo, ano_lancamento FROM filmes ORDER BY ano_lancamento ASC, titulo DESC; -- dois critérios

-- DISTINCT: remove duplicatas
SELECT DISTINCT pais FROM diretores; -- Reino Unido, Canadá (sem repetir)
SELECT COUNT(DISTINCT diretor_id) FROM filmes; -- quantos diretores diferentes

-- LIMIT/OFFSET: paginação
SELECT titulo FROM filmes ORDER BY id LIMIT 2;           -- primeiros 2
SELECT titulo FROM filmes ORDER BY id LIMIT 2 OFFSET 2;  -- pula 2, pega 2 (página 2)
SELECT titulo FROM filmes ORDER BY id LIMIT 2, 2;        -- MySQL atalho: LIMIT offset, qtd

-- PG padrão: SELECT ... OFFSET 2 ROWS FETCH NEXT 2 ROWS ONLY;

-- Top 2 filmes mais bem avaliados
SELECT titulo, nota_imdb FROM filmes ORDER BY nota_imdb DESC LIMIT 2;
-- Sem ORDER BY + LIMIT, o "top 2" é aleatório!

-- Combinação real: página 2 de filmes recentes (2 por página)
SELECT titulo FROM filmes ORDER BY ano_lancamento DESC LIMIT 2 OFFSET 2;
```

**Erro comum:**

```sql
SELECT * FROM filmes WHERE titulo = NULL;
-- 0 linhas — use IS NULL (cap. 04.2)
SELECT * FROM filmes ORDER BY nota_imdb WHERE nota_imdb > 8;
-- ERROR: WHERE vem antes de ORDER BY — ordem é FROM → WHERE → ORDER BY
```

---

⬅️ [Anterior: INSERT](./05-dml-insert.md) | [Próximo: Funções e Agregação](./07-funcoes-agregacao.md) | [Sumário](./README.md)
