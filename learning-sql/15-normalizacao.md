# 15. Normalização — 1FN, 2FN, 3FN e BCNF

> Parte do [Curso Completo de SQL](./README.md)

Por que `filme_generos` existe em vez de `filmes.generos VARCHAR`? Normalização.

## 15.1 Tabela desnormalizada (problema)

```sql
-- ❌ 0FN: um filme com gêneros concatenados (viola 1FN)
CREATE TABLE filmes_denormalizados (
    id INT PRIMARY KEY,
    titulo VARCHAR(150),
    generos VARCHAR(255) -- 'Ficção, Ação, Aventura' — não atômico!
);
-- Problemas: não dá para fazer JOIN, COUNT por gênero, índice, UPDATE parcial.
```

## 15.2 1FN — Atômico

> Cada célula contém valor indivisível. Sem listas, sem repetição de grupos.

```sql
-- ✅ 1FN: separar em tabela filha
-- filmes (1) ──N filme_generos N──1 generos
-- Já feito no cap. 03 — filme_generos é 1FN.
```

**Regra:** se você precisa de `FIND_IN_SET()` ou `LIKE '%Ação%'`, está violando 1FN.

## 15.3 2FN — Depende da chave toda

> Só se aplica a chaves compostas. Todo atributo não-chave depende da *chave inteira*.

```sql
-- ❌ Viola 2FN: genero_nome depende só de genero_id, não de (filme_id, genero_id)
CREATE TABLE filme_generos_errado (
    filme_id INT, genero_id INT, genero_nome VARCHAR(50),
    PRIMARY KEY (filme_id, genero_id)
);

-- ✅ 2FN: genero_nome vai para generos
CREATE TABLE generos (id INT PRIMARY KEY, nome VARCHAR(50) UNIQUE);
CREATE TABLE filme_generos (filme_id INT, genero_id INT, PRIMARY KEY (filme_id, genero_id));
```

## 15.4 3FN — Sem dependência transitiva

> Atributo não-chave não depende de outro não-chave.

```sql
-- ❌ Viola 3FN: pais_diretor depende de diretor, não do filme
CREATE TABLE filmes_3fn_errado (
    id INT PRIMARY KEY, titulo VARCHAR(150), diretor_nome VARCHAR(100), pais_diretor VARCHAR(50)
);
-- Se Nolan muda de país, atualiza N filmes — anomalia.

-- ✅ 3FN: extrai diretores
CREATE TABLE diretores (id INT PRIMARY KEY, nome VARCHAR(100), pais VARCHAR(50));
CREATE TABLE filmes (id INT PRIMARY KEY, titulo VARCHAR(150), diretor_id INT, FOREIGN KEY (diretor_id) REFERENCES diretores(id));
```

## 15.5 BCNF — Toda determinante é superchave

> Versão mais forte da 3FN. No nosso domínio, `avaliacoes (filme_id, usuario_id) → nota` já está em BCNF porque a determinante é a chave composta `(filme_id, usuario_id)` (UNIQUE no cap. 03).

```sql
-- Exemplo de violação BCNF (fora do catálogo, didático):
-- sala (filme_id, horario) -> sala_numero, mas sala_numero -> horario (determinante não é superchave)
-- Solução: decompor em duas tabelas.
```

## 15.6 Quando desnormalizar?

| Sinal | O que fazer |
|-------|-------------|
| `JOIN` de 5 tabelas em relatório crítico com `EXPLAIN` lento | Criar view materializada ou coluna `generos_cache` + trigger |
| `COUNT(*)` por gênero toda hora | Coluna `generos.total_filmes` mantida por trigger |
| Leitura 100x > escrita | Desnormalização controlada é válida |

> Regra: **normalize até 3FN por padrão, desnormalize só com métrica (`EXPLAIN ANALYZE`) e mantendo integridade via trigger.**

**Exemplo desnormalização controlada:**

```sql
ALTER TABLE filmes ADD COLUMN generos_cache VARCHAR(255);
-- Trigger mantém sincronizado (ver cap. 12)
CREATE TRIGGER trg_sync_generos AFTER INSERT ON filme_generos
FOR EACH ROW UPDATE filmes SET generos_cache = (
    SELECT GROUP_CONCAT(g.nome) FROM filme_generos fg JOIN generos g ON g.id=fg.genero_id WHERE fg.filme_id=NEW.filme_id
) WHERE id=NEW.filme_id;
```

---

⬅️ [Anterior: Boas Práticas](./14-boas-praticas-apendice.md) | [Próximo: Agregação Avançada](./16-agregacao-avancada.md) | [Sumário](./README.md)
