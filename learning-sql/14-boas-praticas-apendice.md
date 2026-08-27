# 14. Boas Práticas e Apêndice

> Parte do [Curso Completo de SQL](./README.md)

## 14.1 Boas Práticas

- **Nunca `UPDATE`/`DELETE` sem `WHERE`** — teste com `SELECT` antes.
- **Evite `SELECT *`** — liste colunas, melhora performance e legibilidade.
- **Índices com consciência** — `EXPLAIN` antes e depois.
- **Transações para operações atômicas** — transferências, avaliações.
- **Use `FOREIGN KEY` sempre** — garante integridade.
- **Normalize até 3FN**, desnormalize só se medir ganho.
- **Padronize nomes:** `snake_case`, tabelas no plural ou singular (escolha um).
- **Documente com comentários** `--` e `/* */`.
- **Trate `NULL` com `COALESCE`**, não com `= NULL`.
- **Prefira `EXISTS` a `IN` em subqueries grandes.**

## 14.2 Apêndice

### Script completo

Importe em uma linha:

```bash
mysql -u root -p < projeto-catalogo-filmes.sql
# ou dentro do container: docker-compose exec mysql mysql -u root -p catalogo_filmes < /var/www/projeto-catalogo-filmes.sql
```

O arquivo [`projeto-catalogo-filmes.sql`](./projeto-catalogo-filmes.sql) na mesma pasta contém: DDL completo, INSERTs de seed, Views, Procedures e todas as consultas do cap. 13 — pronto para rodar.

### Exercícios propostos

1. Adicione tabela `premios` (id, nome, ano) e relacione N:N com filmes.
2. Crie uma view `vw_ranking_generos` com top 3 filmes por gênero usando `ROW_NUMBER()`.
3. Escreva uma procedure `sp_relatorio_diretor(p_diretor_id)` que retorna filmes e média.
4. Crie um trigger que impede `nota_imdb > 10`.
5. Otimize `SELECT ... WHERE titulo LIKE '%inception%'` com `FULLTEXT`.

### Referência rápida

| Comando | Função |
|---------|--------|
| `SHOW TABLES;` | Lista tabelas |
| `DESCRIBE filmes;` | Estrutura da tabela |
| `SHOW CREATE TABLE filmes;` | DDL da tabela |
| `EXPLAIN SELECT ...` | Plano de execução |
| `SHOW INDEX FROM filmes;` | Índices |

---

> **Próximo passo:** explore `projeto-catalogo-filmes.sql`, modifique as consultas do cap. 13 e crie suas próprias análises — é assim que se domina SQL.

Autor: Ryan Oliveira — Estudo contínuo.

---

⬅️ [Anterior: Projeto Final](./13-projeto-final.md) | [Próximo: Normalização](./15-normalizacao.md) | [Sumário](./README.md)
