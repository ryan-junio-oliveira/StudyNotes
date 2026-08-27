# 17. JSON Avançado no MySQL 8

> Parte do [Curso Completo de SQL](./README.md)

## 17.1 Coluna JSON e validação

```sql
ALTER TABLE filmes ADD COLUMN metadados JSON;

-- CHECK com JSON_VALID
ALTER TABLE filmes ADD CONSTRAINT chk_metadados_json CHECK (JSON_VALID(metadados));

-- Insert
UPDATE filmes SET metadados = JSON_OBJECT('premios', JSON_ARRAY('Oscar','BAFTA'), 'idioma', 'EN', '4k', true) WHERE id=1;
UPDATE filmes SET metadados = '{"premios":["Oscar"],"idioma":"EN","duracao_estendida": 10}' WHERE id=2;
```

## 17.2 Funções JSON essenciais

```sql
-- Extrair
SELECT titulo, JSON_EXTRACT(metadados, '$.premios') AS premios,
       JSON_UNQUOTE(JSON_EXTRACT(metadados, '$.idioma')) AS idioma,
       metadados->>'$.idioma' AS idioma_atalho -- MySQL 8
FROM filmes;

-- Criar/modificar
SELECT JSON_OBJECT('titulo', titulo, 'nota', nota_imdb) FROM filmes;
SELECT JSON_ARRAY(g.nome) FROM generos g; -- agregação
SELECT JSON_SET(metadados, '$.visto', true), JSON_INSERT(metadados, '$.novo', 1), JSON_REPLACE(metadados, '$.idioma', 'PT') FROM filmes;

-- Buscar
SELECT * FROM filmes WHERE JSON_CONTAINS(metadados, '"Oscar"', '$.premios');
SELECT * FROM filmes WHERE metadados->>'$.idioma' = 'EN';
SELECT JSON_LENGTH(metadados, '$.premios'), JSON_KEYS(metadados), JSON_SEARCH(metadados, 'one', 'Oscar') FROM filmes;

-- Remover
SELECT JSON_REMOVE(metadados, '$.4k') FROM filmes;
```

## 17.3 JSON_TABLE — JSON vira linhas

```sql
-- Cada prêmio vira uma linha
SELECT f.titulo, j.premio
FROM filmes f,
JSON_TABLE(f.metadados, '$.premios[*]' COLUMNS (premio VARCHAR(50) PATH '$')) AS j
WHERE f.metadados IS NOT NULL;

-- Índices em JSON: coluna virtual + índice
ALTER TABLE filmes ADD COLUMN idioma_virtual VARCHAR(10) GENERATED ALWAYS AS (metadados->>'$.idioma') VIRTUAL;
CREATE INDEX idx_filmes_idioma ON filmes(idioma_virtual);
-- Agora WHERE idioma_virtual='EN' usa índice (JSON direto não usa)
EXPLAIN SELECT * FROM filmes WHERE idioma_virtual='EN';

-- Agregação JSON
SELECT JSON_ARRAYAGG(titulo) AS todos_titulos, JSON_OBJECTAGG(id, titulo) AS mapa FROM filmes;
```

> **Quando usar JSON:** metadados semi-estruturados, flexíveis. **Quando não usar:** dados que precisam de FK, JOIN ou agregação frequente — normalize (cap. 15).

---

⬅️ [Anterior: Agregação Avançada](./16-agregacao-avancada.md) | [Próximo: Particionamento](./18-particionamento.md) | [Sumário](./README.md)
