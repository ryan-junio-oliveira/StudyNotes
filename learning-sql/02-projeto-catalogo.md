# 02. O Projeto: Catálogo de Filmes — Chaves e Relacionamentos na Prática

> Parte do [Curso Completo de SQL](./README.md)
> **Objetivo:** entender **o que é cada conceito** antes de digitar `CREATE TABLE`.

Vamos construir um IMDb simplificado. Esqueça `clientes/pedidos` genéricos — todo exemplo usa o mesmo domínio.

## 2.1 Visão geral — Modelo ER explicado

```
diretores 1──N filmes N──N generos (via filme_generos)
filmes N──N atores (via filme_atores)    filmes 1──N avaliacoes N──1 usuarios
```

O que significa `1──N`? **Um para muitos:**

- **1 diretor** faz **N filmes** (Nolan → Inception, Interstellar)
- **1 filme** tem **N gêneros**, e **1 gênero** está em **N filmes** → precisa de tabela no meio (`filme_generos`)

| Tabela | Papel | Exemplo real |
|--------|-------|--------------|
| `diretores` | Quem dirigiu | Nolan (id=1) |
| `filmes` | Centro de tudo | Inception (id=1) |
| `generos` | Categorias | Ficção (id=1) |
| `atores` | Quem atuou | DiCaprio (id=1) |
| `filme_generos` | Liga filme↔gênero | (1,1) = Inception é Ficção |
| `filme_atores` | Liga filme↔ator + papel | (1,1,'Cobb') |
| `usuarios` | Quem avalia | Ana (id=1) |
| `avaliacoes` | Nota 1–5 | Ana deu 5 em Inception |

## 2.2 PRIMARY KEY — A identidade da linha

> **Definição para leigos:** PRIMARY KEY é o **CPF da linha**. Único, nunca repete, nunca é NULL.

```sql
CREATE TABLE diretores (
    id INT PRIMARY KEY AUTO_INCREMENT, -- ← PRIMARY KEY aqui
    nome VARCHAR(100) NOT NULL
);
```

Visual:

```
diretores
┌────┬─────────────────────┐
│ id │ nome                │  ← id é PRIMARY KEY
├────┼─────────────────────┤
│ 1  │ Christopher Nolan   │  ✅ único
│ 2  │ Denis Villeneuve    │  ✅ único
│ 1  │ Outro Nolan         │  ❌ ERRO: Duplicate entry '1' for key 'PRIMARY'
└────┴─────────────────────┘
```

- `INT` = número, `AUTO_INCREMENT` = banco numera sozinho (1,2,3...)
- **Por que existe?** Sem PK, você não consegue dizer *qual* linha atualizar/apagar.
- **Composta:** `PRIMARY KEY (filme_id, genero_id)` em `filme_generos` — a dupla é única, não cada coluna sozinha.

**Erro comum:**

```sql
INSERT INTO diretores (id, nome) VALUES (1, 'Teste');
-- ERROR 1062: Duplicate entry '1' for key 'PRIMARY'
-- Solução: omita o id → INSERT INTO diretores (nome) VALUES ('Teste')
```

## 2.3 FOREIGN KEY + REFERENCES — O link entre tabelas

> **Definição:** FOREIGN KEY é uma coluna que **copia** a PRIMARY KEY de outra tabela. `REFERENCES` diz **de onde** copia.

```sql
CREATE TABLE filmes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    diretor_id INT, -- ← FOREIGN KEY
    FOREIGN KEY (diretor_id) REFERENCES diretores(id)
    --        coluna local  →  tabela(coluna) de origem
);
```

Visual com dados:

```
diretores              filmes
┌────┬────────┐       ┌────┬──────────────┬────────────┐
│ id │ nome   │       │ id │ titulo       │ diretor_id │ ← FK
├────┼────────┤       ├────┼──────────────┼────────────┤
│ 1  │ Nolan  │◄──────┤ 1  │ Inception    │ 1          │ ✅ existe diretor 1
│ 2  │ Villen.│◄──────┤ 2  │ Dune         │ 2          │ ✅ existe diretor 2
└────┴────────┘       │ 3  │ Filme X      │ 99         │ ❌ ERRO: diretor 99 não existe
                      └────┴──────────────┴────────────┘
```

**O que `REFERENCES` faz?** O banco **impede sujeira:**

```sql
INSERT INTO filmes (titulo, diretor_id) VALUES ('Erro', 99);
-- ERROR 1452: Cannot add or update a child row: a foreign key constraint fails
-- MySQL te protegeu de criar um filme órfão.

DELETE FROM diretores WHERE id=1;
-- Se ainda há filmes com diretor_id=1, o banco bloqueia (ou faz ON DELETE SET NULL/CASCADE — ver cap. 04)
```

## 2.4 UNIQUE, NOT NULL, DEFAULT, CHECK — As outras regras

Cada um é um **tipo de trava** diferente:

| Constraint | Trava que impõe | Exemplo no projeto | O que impede |
|------------|-----------------|-------------------|--------------|
| `UNIQUE` | Não repete | `generos.nome UNIQUE` | Duas vezes "Drama" ❌ |
| `NOT NULL` | Obrigatório | `filmes.titulo NOT NULL` | Filme sem título ❌ |
| `DEFAULT` | Valor se omitido | `orcamento DEFAULT 0` | `NULL` vira `0` ✅ |
| `CHECK` | Regra custom | `nota_imdb CHECK (0–10)` | Nota 99 ❌ |
| `PRIMARY KEY` | `UNIQUE` + `NOT NULL` + identifica | `diretores.id` | Tudo acima junto |
| `FOREIGN KEY` | Só aceita valor que existe na outra tabela | `filmes.diretor_id` | Diretor fantasma ❌ |

**Demonstração rápida:**

```sql
-- UNIQUE
INSERT INTO generos (nome) VALUES ('Drama'), ('Drama');
-- ERROR 1062: Duplicate entry 'Drama' for key 'nome'

-- NOT NULL
INSERT INTO filmes (titulo) VALUES (NULL);
-- ERROR 1048: Column 'titulo' cannot be null

-- CHECK
INSERT INTO filmes (titulo, nota_imdb) VALUES ('Teste', 15);
-- ERROR 3819: Check constraint 'filmes_chk_1' is violated

-- DEFAULT
INSERT INTO filmes (titulo, ano_lancamento) VALUES ('Sem orçamento', 2024);
-- orcamento vira 0 automaticamente
SELECT titulo, orcamento FROM filmes WHERE titulo='Sem orçamento'; -- 0
```

## 2.5 Tipos de relacionamento

| Tipo | Exemplo catálogo | Como fazer |
|------|------------------|------------|
| **1:N** (um-para-muitos) | 1 diretor → N filmes | FK em `filmes.diretor_id` |
| **N:N** (muitos-para-muitos) | N filmes ↔ N generos | Tabela ponte `filme_generos` com 2 FKs + PK composta |
| **1:1** (um-para-um) | 1 filme → 1 poster detalhado | FK com UNIQUE |

**Por que precisa de tabela ponte no N:N?**

```
❌ Errado: filmes.generos = 'Ficção, Ação' — viola 1FN, não dá para fazer JOIN
✅ Certo: filme_generos (filme_id, genero_id) — cada linha é um par
   (1,1) Inception-Ficção
   (1,3) Inception-Ação
```

---

## Próximo

➡️ [03. DDL — Criando Banco e Tabelas (dissecado linha a linha)](./03-ddl-tabelas.md)

⬅️ [Anterior: Introdução](./01-introducao.md) | [Sumário](./README.md)
