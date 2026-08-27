# 18. Particionamento

> Parte do [Curso Completo de SQL](./README.md)

Para tabelas grandes (milhões de linhas). No catálogo, `avaliacoes` é candidata.

## 18.1 RANGE — por intervalo

```sql
-- Particiona avaliacoes por ano da avaliação
CREATE TABLE avaliacoes_part (
    id INT NOT NULL AUTO_INCREMENT,
    filme_id INT NOT NULL,
    usuario_id INT NOT NULL,
    nota TINYINT NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, criado_em) -- PK deve incluir coluna de partição
)
PARTITION BY RANGE (YEAR(criado_em)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

-- Partition pruning: só lê p2024
EXPLAIN SELECT * FROM avaliacoes_part WHERE YEAR(criado_em)=2024;
```

## 18.2 LIST — por lista de valores

```sql
-- Particiona filmes por classificação
CREATE TABLE filmes_part (
    id INT PRIMARY KEY,
    titulo VARCHAR(150),
    classificacao ENUM('L','10','12','14','16','18')
)
PARTITION BY LIST COLUMNS(classificacao) (
    PARTITION p_livre VALUES IN ('L'),
    PARTITION p_jovem VALUES IN ('10','12'),
    PARTITION p_adulto VALUES IN ('14','16','18')
);
```

## 18.3 HASH — distribuição uniforme

```sql
-- Distribui por hash do filme_id (8 partições)
CREATE TABLE avaliacoes_hash (
    id INT PRIMARY KEY, filme_id INT, nota TINYINT
)
PARTITION BY HASH(filme_id) PARTITIONS 8;
```

## 18.4 Gerenciamento

```sql
ALTER TABLE avaliacoes_part ADD PARTITION (PARTITION p2025 VALUES LESS THAN (2026));
ALTER TABLE avaliacoes_part DROP PARTITION p2022;
ALTER TABLE avaliacoes_part TRUNCATE PARTITION p2023; -- mais rápido que DELETE

-- Ver partições
SELECT PARTITION_NAME, TABLE_ROWS FROM information_schema.PARTITIONS WHERE TABLE_NAME='avaliacoes_part';
EXPLAIN SELECT * FROM avaliacoes_part WHERE criado_em BETWEEN '2024-01-01' AND '2024-12-31'; -- pruning
```

> **Quando particionar:** tabela > 10M linhas ou queries sempre filtram por `criado_em`/`ano`. **Quando não:** catálogo pequeno — índice (`11-indices-views.md:1`) já resolve. Particionamento sem pruning piora performance.

---

⬅️ [Anterior: JSON](./17-json-avancado.md) | [Próximo: Concorrência e Cursores](./19-concorrencia-cursores.md) | [Sumário](./README.md)
