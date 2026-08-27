# 04. Tipos de Dados e Constraints — Guia Visual

> Parte do [Curso Completo de SQL](./README.md)
> **Constraints = travas que protegem o dado.** Cada uma com analogia, exemplo e erro real.

## 4.1 Tipos de Dados — Escolhendo o tipo certo

| Família | MySQL | Quando usar | Exemplo projeto | Se escolher errado |
|---------|-------|-------------|-----------------|-------------------|
| **Numérico inteiro** | `INT`, `TINYINT` | Ids, duração, nota 1-5 | `duracao_min INT`, `nota TINYINT` | `INT` para nota desperdiça espaço |
| **Numérico decimal** | `DECIMAL(12,2)` | Dinheiro, nota precisa | `orcamento DECIMAL(12,2)`, `nota_imdb DECIMAL(3,1)` | `FLOAT` dá `8.799999` em vez de `8.8` |
| **Texto curto** | `VARCHAR(n)` | Texto com limite | `titulo VARCHAR(150)` até 150 chars | `VARCHAR(10)` corta "Interstellar" |
| **Texto longo** | `TEXT`, `MEDIUMTEXT` | Sinopse, comentário | `sinopse TEXT` (64KB), `MEDIUMTEXT` (16MB) | `VARCHAR` para sinopse estoura |
| **Texto fixo/enum** | `ENUM('L','14')` | Lista fechada | `classificacao ENUM` | `VARCHAR` deixa "XPTO" passar |
| **Data** | `DATE`, `YEAR`, `TIMESTAMP` | Datas | `ano_lancamento YEAR`, `criado_em TIMESTAMP` | `VARCHAR` para data não valida "32/13/2024" |
| **Outros** | `JSON`, `BOOLEAN` | Metadados, flag | `metadados JSON` | — |

> **Regra de ouro:** `VARCHAR` com limite real, `TEXT` só para longo, `DECIMAL` para dinheiro/nota, `TIMESTAMP` para carimbo. Nunca `FLOAT` para dinheiro.

```sql
-- Exemplos práticos
titulo VARCHAR(150)  -- "Inception" cabe, "abc... 200 chars" ❌ cortado/erro
nota_imdb DECIMAL(3,1) -- 8.8 cabe, 88.8 ❌ excede 3 dígitos
ano_lancamento YEAR  -- 2010 cabe, 'abc' ❌ erro
```

## 4.2 Constraints — Cada trava explicada

### PRIMARY KEY — Identidade única

> Como CPF. Obrigatório, único, nunca NULL. Sem ela, você não consegue atualizar/apagar *aquela* linha.

```sql
-- Sintaxe inline (na coluna)
id INT PRIMARY KEY AUTO_INCREMENT

-- Sintaxe out-of-line (no final)
id INT AUTO_INCREMENT,
PRIMARY KEY (id)

-- Composta (dupla é única)
PRIMARY KEY (filme_id, genero_id) -- em filme_generos
```

| Pergunta | Resposta |
|----------|----------|
| Pode repetir? | Não → `Duplicate entry '1'` |
| Pode ser NULL? | Não |
| Pode ter 2 PKs? | Não, só uma (simples ou composta) |
| `AUTO_INCREMENT`? | MySQL numera sozinho. `INSERT (nome) VALUES ('Nolan')` → id=1 automático |

**Natural vs Surrogate:** `email` seria PK natural, mas usamos `id` surrogate (número) — mais rápido e estável.

### FOREIGN KEY + REFERENCES — O link

> `FOREIGN KEY` = coluna que **copia** PK de outra tabela. `REFERENCES` = **de onde** copia.

```sql
-- Sintaxe completa
diretor_id INT, -- coluna local
FOREIGN KEY (diretor_id) REFERENCES diretores(id)
  ON DELETE SET NULL   -- se apagar diretor, vira NULL
  ON UPDATE CASCADE    -- se mudar id do diretor, replica
```

| `ON DELETE` | O que faz ao apagar o pai | Quando usar |
|-------------|---------------------------|-------------|
| `CASCADE` | Apaga filhos também | `avaliacoes` → se apaga filme, apaga avaliações |
| `SET NULL` | Filhos viram `NULL` | `filmes.diretor_id` → filme fica sem diretor |
| `RESTRICT` | Bloqueia se há filhos | Padrão — protege de apagar diretor com filmes |
| `NO ACTION` | Igual RESTRICT (MySQL) | — |

**Erro didático:**

```sql
INSERT INTO filmes (titulo, diretor_id) VALUES ('Teste', 99);
-- ERROR 1452: Cannot add child row: foreign key fails — diretor 99 não existe
-- Correção: INSERT INTO diretores ... primeiro
```

### UNIQUE — Sem repetição

> Como `FOREIGN KEY` sem `REFERENCES` — só impede duplicata.

```sql
email VARCHAR(150) NOT NULL UNIQUE  -- inline
UNIQUE (filme_id, usuario_id)       -- out-of-line, par único (1 avaliação por usuário/filme)
```

- `UNIQUE` permite `NULL` (vários `NULL`s são permitidos no MySQL — armadilha!)
- `PRIMARY KEY` = `UNIQUE` + `NOT NULL`

```sql
INSERT INTO generos (nome) VALUES ('Drama'), ('Drama');
-- ERROR 1062: Duplicate entry 'Drama' for key 'generos.nome'
```

### NOT NULL — Obrigatório

```sql
titulo VARCHAR(150) NOT NULL -- não aceita NULL
titulo VARCHAR(150) NULL     -- aceita NULL (padrão se omitir)
```

- `NULL` ≠ `""` ≠ `0` — é "sem valor".
- Verifique: `WHERE sinopse IS NULL` (não `= NULL` — isso nunca funciona!)

```sql
INSERT INTO filmes (titulo) VALUES (NULL);
-- ERROR 1048: Column 'titulo' cannot be null
```

### DEFAULT — Valor se omitir

```sql
orcamento DECIMAL(12,2) DEFAULT 0
classificacao ENUM('L','14') DEFAULT 'L'
criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

```sql
INSERT INTO filmes (titulo, ano_lancamento) VALUES ('Novo', 2024);
-- orcamento = 0, classificacao = 'L', criado_em = NOW() automaticamente
```

### CHECK — Regra custom

```sql
nota_imdb DECIMAL(3,1) CHECK (nota_imdb BETWEEN 0 AND 10)
duracao_min INT CHECK (duracao_min > 0)
-- Nomeado:
CONSTRAINT chk_ano_valido CHECK (ano_lancamento BETWEEN 1888 AND 2030)
```

```sql
INSERT INTO filmes (titulo, nota_imdb) VALUES ('X', 15);
-- ERROR 3819: Check constraint violated
```

## 4.3 Resumo visual

```
diretores                          filmes
┌────┬──────────────┐  FK           ┌────┬──────────────┬────────────┬──────────┐
│ id │ nome         │   ┌──────────►│ id │ titulo       │ diretor_id │ nota_imdb│
│ PK │ UNIQUE? Não  │   │  REFERENCES│ PK │ NOT NULL     │ FK         │ CHECK    │
├────┼──────────────┤   │           ├────┼──────────────┼────────────┼──────────┤
│ 1  │ Nolan        │◄──┘           │ 1  │ Inception    │ 1          │ 8.8      │
│ 2  │ Villeneuve   │               │ 2  │ Dune         │ 2          │ 8.5      │
└────┴──────────────┘               └────┴──────────────┴────────────┴──────────┘
         ▲                                UNIQUE? Não      REFERENCES diretores(id)
         │                                NOT NULL? Sim    ON DELETE SET NULL
         └──── PRIMARY KEY (id) ────────── FOREIGN KEY (diretor_id)
```

> **Como ler `SHOW CREATE TABLE filmes`:** veja as linhas `PRIMARY KEY`, `UNIQUE KEY`, `CONSTRAINT ... FOREIGN KEY`, `CHECK` — todas as travas estão lá.

---

⬅️ [Anterior: DDL](./03-ddl-tabelas.md) | [Próximo: INSERT (sintaxe detalhada)](./05-dml-insert.md) | [Sumário](./README.md)
