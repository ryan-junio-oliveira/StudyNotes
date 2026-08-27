# 04. Tipos de Dados e Constraints

> Parte do [Curso Completo de SQL](./README.md)

## 4.1 Tipos de Dados

| Família | MySQL | Uso no projeto |
|---------|-------|----------------|
| Numérico | `INT`, `TINYINT`, `DECIMAL(12,2)`, `FLOAT` | `duracao_min`, `nota` |
| Texto | `VARCHAR(150)`, `TEXT`, `MEDIUMTEXT`, `ENUM` | `titulo`, `sinopse`, `classificacao` |
| Data | `DATE`, `YEAR`, `TIMESTAMP`, `DATETIME` | `ano_lancamento`, `criado_em` |
| Outros | `JSON`, `BOOLEAN` (alias TINYINT(1)) | `config` futuro |

> Dica: use `VARCHAR` com limite real, `TEXT` só para textos longos. `DECIMAL` para dinheiro/nota, nunca `FLOAT`.

## 4.2 Constraints — Regras de Integridade

```sql
-- NOT NULL + UNIQUE + CHECK + DEFAULT já vistos no cap. 03.
-- Exemplo explícito de CHECK composto:
ALTER TABLE filmes ADD CONSTRAINT chk_ano_valido CHECK (ano_lancamento BETWEEN 1888 AND 2030);

-- FOREIGN KEY com ações:
-- ON DELETE CASCADE (apaga filhos), SET NULL, RESTRICT, NO ACTION
-- ON UPDATE CASCADE

-- PRIMARY KEY composta já usada em filme_generos (filme_id, genero_id)
```

**Resumo:**

- `PRIMARY KEY` — identifica linha
- `FOREIGN KEY` — integridade referencial
- `UNIQUE` — sem duplicatas
- `NOT NULL` — obrigatório
- `CHECK` — validação custom
- `DEFAULT` — valor padrão

---

⬅️ [Anterior: DDL](./03-ddl-tabelas.md) | [Próximo: INSERT](./05-dml-insert.md) | [Sumário](./README.md)
