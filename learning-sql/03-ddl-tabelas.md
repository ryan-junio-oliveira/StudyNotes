# 03. DDL — Criando Banco e Tabelas (dissecado)

> Parte do [Curso Completo de SQL](./README.md)
> **DDL = Data Definition Language** — comandos que **definem a estrutura** (não os dados).

## 3.1 CREATE DATABASE — Criar o banco

```sql
CREATE DATABASE catalogo_filmes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

| Parte | O que significa | Se omitir |
|-------|-----------------|-----------|
| `CREATE DATABASE catalogo_filmes` | Cria o arquivo-biblioteca | Erro: banco já existe? Use `IF NOT EXISTS` |
| `CHARACTER SET utf8mb4` | Suporta acento, emoji, japonês | `latin1` quebra "São Paulo" |
| `COLLATE utf8mb4_unicode_ci` | `ci` = case-insensitive (`'nolan'='Nolan'`) | Comparação fica sensível |

```sql
-- Usar o banco (MySQL)
USE catalogo_filmes;

-- Ver bancos e entrar
SHOW DATABASES;  -- lista
DROP DATABASE IF EXISTS catalogo_filmes; -- apaga (cuidado!)

-- PG: CREATE DATABASE catalogo_filmes ENCODING 'UTF8'; + \c catalogo_filmes
```

**Erro comum:**

```sql
CREATE DATABASE catalogo_filmes;
-- ERROR 1007: Can't create database 'catalogo_filmes'; database exists
-- Solução: CREATE DATABASE IF NOT EXISTS catalogo_filmes;
```

## 3.2 CREATE TABLE — Dissecado linha a linha

Vamos dissecar a tabela mais importante:

```sql
CREATE TABLE filmes (                          -- 1. Cria tabela "filmes"
    id INT PRIMARY KEY AUTO_INCREMENT,          -- 2. PK numérica auto-numerada
    titulo VARCHAR(150) NOT NULL,               -- 3. Texto obrigatório, até 150 chars
    ano_lancamento YEAR NOT NULL,               -- 4. Ano (2010) — MySQL; PG use SMALLINT
    duracao_min INT CHECK (duracao_min > 0),    -- 5. Minutos, deve ser >0
    sinopse TEXT,                               -- 6. Texto longo, pode ser NULL
    nota_imdb DECIMAL(3,1) CHECK (nota_imdb BETWEEN 0 AND 10), -- 7. 8.8, regra 0-10
    diretor_id INT,                             -- 8. FK (pode ser NULL = filme sem diretor)
    orcamento DECIMAL(12,2) DEFAULT 0,          -- 9. Dinheiro, padrão 0
    poster_url VARCHAR(255),                    -- 10. Link, opcional
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 11. Carimbo de criação
    FOREIGN KEY (diretor_id) REFERENCES diretores(id) ON DELETE SET NULL -- 12. Liga com diretores
);
```

**Linha por linha:**

- **1. `CREATE TABLE filmes (`** — nome da tabela, sempre `snake_case`.
- **2. `id INT PRIMARY KEY AUTO_INCREMENT`** — identidade única (ver cap. 02.2). `AUTO_INCREMENT` = 1,2,3 automático.
- **3. `titulo VARCHAR(150) NOT NULL`** — `VARCHAR` = texto variável. `NOT NULL` = não aceita `NULL` (ver cap. 02.4).
- **5. `CHECK (duracao_min > 0)`** — trava que impede `-10` minutos.
- **8. `diretor_id INT`** — coluna FK ainda **sem trava**; a trava vem na linha 12.
- **11. `TIMESTAMP DEFAULT CURRENT_TIMESTAMP`** — se não informar, grava `NOW()`.
- **12. `FOREIGN KEY ... REFERENCES ...`** — **liga** `filmes.diretor_id` → `diretores.id`. `ON DELETE SET NULL` = se apagar Nolan, `diretor_id` vira `NULL` (não apaga filmes).

### As outras tabelas (mesmo padrão)

```sql
CREATE TABLE diretores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    data_nascimento DATE, -- YYYY-MM-DD
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE generos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE -- UNIQUE = não repete "Drama" (ver cap. 02.4)
);

CREATE TABLE atores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE
);

-- N:N: filme ↔ gênero (tabela ponte)
CREATE TABLE filme_generos (
    filme_id INT NOT NULL,
    genero_id INT NOT NULL,
    PRIMARY KEY (filme_id, genero_id), -- PK composta: par único
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE, -- se apaga filme, apaga pares
    FOREIGN KEY (genero_id) REFERENCES generos(id) ON DELETE CASCADE
);

-- N:N: filme ↔ ator (+ personagem)
CREATE TABLE filme_atores (
    filme_id INT NOT NULL,
    ator_id INT NOT NULL,
    personagem VARCHAR(100),
    PRIMARY KEY (filme_id, ator_id),
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE,
    FOREIGN KEY (ator_id) REFERENCES atores(id) ON DELETE CASCADE
);

CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE, -- email não repete
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE avaliacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    filme_id INT NOT NULL,
    usuario_id INT NOT NULL,
    nota TINYINT NOT NULL CHECK (nota BETWEEN 1 AND 5), -- 1 a 5
    comentario TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (filme_id, usuario_id), -- 1 avaliação por usuário/filme (não pode avaliar 2x)
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
```

**Como saber se criou certo?**

```sql
SHOW TABLES;           -- lista tabelas
DESCRIBE filmes;       -- colunas + tipos + constraints
SHOW CREATE TABLE filmes; -- DDL exato que o banco guardou
```

## 3.3 ALTER, DROP e TRUNCATE — Comandos de manutenção

```sql
-- ALTER: alterar estrutura (sem apagar dados)
ALTER TABLE filmes ADD COLUMN classificacao ENUM('L','10','12','14','16','18') DEFAULT 'L';
-- ADD COLUMN = adiciona coluna nova

ALTER TABLE filmes MODIFY COLUMN sinopse MEDIUMTEXT;
-- MODIFY = muda tipo (TEXT 64KB → MEDIUMTEXT 16MB)

ALTER TABLE filmes RENAME COLUMN poster_url TO url_poster; -- MySQL 8
-- RENAME COLUMN = renomeia

ALTER TABLE filmes DROP COLUMN url_poster;
-- DROP COLUMN = remove coluna (irreversível!)

-- DROP: apaga tabela/banco inteiro
DROP TABLE IF EXISTS filme_atores; -- IF EXISTS evita erro se já apagou
DROP DATABASE catalogo_filmes; -- apaga tudo — use com WHERE mental!

-- TRUNCATE: esvazia tabela (mais rápido que DELETE, reseta AUTO_INCREMENT)
TRUNCATE TABLE avaliacoes; -- apaga todas as avaliações, mantém estrutura

-- Índices (ver cap. 11) são DDL também
CREATE INDEX idx_filmes_ano ON filmes(ano_lancamento);
DROP INDEX idx_filmes_ano ON filmes;
```

| Comando | Apaga estrutura? | Apaga dados? | Pode desfazer? | Velocidade |
|---------|-----------------|--------------|----------------|------------|
| `DROP TABLE` | Sim | Sim | Não | Rápido |
| `TRUNCATE` | Não | Sim | Não | Muito rápido |
| `DELETE FROM filmes` | Não | Sim | Sim (com TRANSACTION) | Lento |

**Erro comum:**

```sql
ALTER TABLE filmes ADD COLUMN ano_lancamento YEAR;
-- ERROR 1060: Duplicate column name 'ano_lancamento'
-- Já existe — use MODIFY, não ADD.
```

---

⬅️ [Anterior: Projeto](./02-projeto-catalogo.md) | [Próximo: Tipos e Constraints (guia visual)](./04-tipos-constraints.md) | [Sumário](./README.md)
