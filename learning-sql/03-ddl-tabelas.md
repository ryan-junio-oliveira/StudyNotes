# 03. DDL — Criando Banco e Tabelas

> Parte do [Curso Completo de SQL](./README.md)

## 3.1 Criar banco

```sql
CREATE DATABASE catalogo_filmes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE catalogo_filmes;
-- PG: CREATE DATABASE catalogo_filmes ENCODING 'UTF8';
```

## 3.2 Criar tabelas (completo)

```sql
CREATE TABLE diretores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    data_nascimento DATE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE generos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE filmes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    ano_lancamento YEAR NOT NULL,              -- MySQL; PG use SMALLINT
    duracao_min INT CHECK (duracao_min > 0),
    sinopse TEXT,
    nota_imdb DECIMAL(3,1) CHECK (nota_imdb BETWEEN 0 AND 10),
    diretor_id INT,
    orcamento DECIMAL(12,2) DEFAULT 0,
    poster_url VARCHAR(255),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (diretor_id) REFERENCES diretores(id) ON DELETE SET NULL
);

CREATE TABLE atores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE
);

-- N:N filmes <-> generos
CREATE TABLE filme_generos (
    filme_id INT NOT NULL,
    genero_id INT NOT NULL,
    PRIMARY KEY (filme_id, genero_id),
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE,
    FOREIGN KEY (genero_id) REFERENCES generos(id) ON DELETE CASCADE
);

-- N:N filmes <-> atores (com papel)
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
    email VARCHAR(150) NOT NULL UNIQUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE avaliacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    filme_id INT NOT NULL,
    usuario_id INT NOT NULL,
    nota TINYINT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (filme_id, usuario_id), -- 1 avaliação por usuário/filme
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
```

## 3.3 ALTER e DROP

```sql
-- Adicionar coluna
ALTER TABLE filmes ADD COLUMN classificacao ENUM('L','10','12','14','16','18') DEFAULT 'L';

-- Modificar tipo
ALTER TABLE filmes MODIFY COLUMN sinopse MEDIUMTEXT;

-- Renomear coluna (MySQL 8)
ALTER TABLE filmes RENAME COLUMN poster_url TO url_poster;

-- Remover coluna
ALTER TABLE filmes DROP COLUMN url_poster;

-- Criar índice depois (ver cap. 10)
CREATE INDEX idx_filmes_ano ON filmes(ano_lancamento);
```

---

⬅️ [Anterior: Projeto](./02-projeto-catalogo.md) | [Próximo: Tipos e Constraints](./04-tipos-constraints.md) | [Sumário](./README.md)
