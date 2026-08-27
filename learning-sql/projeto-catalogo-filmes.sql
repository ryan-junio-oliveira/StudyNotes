-- =============================================================
-- Projeto Catálogo de Filmes — SQL Puro (MySQL 8.0)
-- =============================================================
-- Como usar:
--   mysql -u root -p < projeto-catalogo-filmes.sql
--   ou: docker-compose exec mysql mysql -u root -p < projeto-catalogo-filmes.sql
-- =============================================================

DROP DATABASE IF EXISTS catalogo_filmes;
CREATE DATABASE catalogo_filmes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE catalogo_filmes;

-- -------------------------------------------------------------
-- DDL
-- -------------------------------------------------------------
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
    ano_lancamento YEAR NOT NULL,
    duracao_min INT CHECK (duracao_min > 0),
    sinopse TEXT,
    nota_imdb DECIMAL(3,1) CHECK (nota_imdb BETWEEN 0 AND 10),
    diretor_id INT,
    orcamento DECIMAL(12,2) DEFAULT 0,
    classificacao ENUM('L','10','12','14','16','18') DEFAULT 'L',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (diretor_id) REFERENCES diretores(id) ON DELETE SET NULL,
    CONSTRAINT chk_ano_valido CHECK (ano_lancamento BETWEEN 1888 AND 2030)
);

CREATE TABLE atores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE
);

CREATE TABLE filme_generos (
    filme_id INT NOT NULL,
    genero_id INT NOT NULL,
    PRIMARY KEY (filme_id, genero_id),
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE,
    FOREIGN KEY (genero_id) REFERENCES generos(id) ON DELETE CASCADE
);

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
    UNIQUE (filme_id, usuario_id),
    FOREIGN KEY (filme_id) REFERENCES filmes(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Log para trigger de auditoria
CREATE TABLE log_filmes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    filme_id INT NOT NULL,
    nota_antiga DECIMAL(3,1),
    nota_nova DECIMAL(3,1),
    alterado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------
-- SEED — Dados conectados (mesmo dataset do README)
-- -------------------------------------------------------------
INSERT INTO diretores (nome, pais, data_nascimento) VALUES
('Christopher Nolan', 'Reino Unido', '1970-07-30'),
('Denis Villeneuve', 'Canadá', '1967-10-03'),
('Greta Gerwig', 'EUA', '1983-08-04');

INSERT INTO generos (nome) VALUES
('Ficção Científica'), ('Drama'), ('Ação'), ('Suspense'), ('Aventura'), ('Comédia');

INSERT INTO atores (nome, data_nascimento) VALUES
('Leonardo DiCaprio', '1974-11-11'),
('Zendaya', '1996-09-01'),
('Timothée Chalamet', '1995-12-27'),
('Matthew McConaughey', '1969-11-04'),
('Margot Robbie', '1990-07-02');

INSERT INTO filmes (titulo, ano_lancamento, duracao_min, sinopse, nota_imdb, diretor_id, orcamento, classificacao) VALUES
('Inception', 2010, 148, 'Um ladrão que rouba segredos do subconsciente.', 8.8, 1, 160000000, '14'),
('Interstellar', 2014, 169, 'Exploradores viajam por um buraco de minhoca.', 8.7, 1, 165000000, '10'),
('Dune: Part One', 2021, 155, 'Paul Atreides em Arrakis.', 8.0, 2, 165000000, '14'),
('Dune: Part Two', 2024, 166, 'A jornada de Paul continua.', 8.5, 2, 190000000, '14'),
('Barbie', 2023, 114, 'Barbie deixa a Barbieland.', 7.0, 3, 145000000, '12');

INSERT INTO filme_generos VALUES
(1,1), (1,4),        -- Inception: Ficção, Suspense
(2,1), (2,2), (2,5), -- Interstellar: Ficção, Drama, Aventura
(3,1), (3,5),        -- Dune 1: Ficção, Aventura
(4,1), (4,3), (4,5), -- Dune 2: Ficção, Ação, Aventura
(5,6), (5,5);        -- Barbie: Comédia, Aventura

INSERT INTO filme_atores (filme_id, ator_id, personagem) VALUES
(1, 1, 'Cobb'),
(2, 4, 'Cooper'),
(3, 2, 'Chani'), (3, 3, 'Paul Atreides'),
(4, 2, 'Chani'), (4, 3, 'Paul Atreides'),
(5, 5, 'Barbie');

INSERT INTO usuarios (nome, email) VALUES
('Ana', 'ana@email.com'),
('Bruno', 'bruno@email.com'),
('Carla', 'carla@email.com');

INSERT INTO avaliacoes (filme_id, usuario_id, nota, comentario) VALUES
(1, 1, 5, 'Obra-prima!'),
(1, 2, 4, 'Muito bom, complexo'),
(1, 3, 5, 'Revi 3 vezes'),
(2, 1, 5, 'Emocionante'),
(2, 2, 5, 'Chorei no final'),
(3, 1, 4, 'Visual incrível'),
(4, 1, 5, 'Melhor que o primeiro'),
(4, 2, 4, 'Épico'),
(5, 3, 3, 'Divertido');

-- -------------------------------------------------------------
-- ÍNDICES
-- -------------------------------------------------------------
CREATE INDEX idx_filmes_diretor ON filmes(diretor_id);
CREATE INDEX idx_filmes_ano_nota ON filmes(ano_lancamento, nota_imdb);
CREATE INDEX idx_avaliacoes_filme_nota ON avaliacoes(filme_id, nota);
CREATE FULLTEXT INDEX idx_filmes_sinopse ON filmes(sinopse);

-- -------------------------------------------------------------
-- VIEWS
-- -------------------------------------------------------------
CREATE VIEW vw_filmes_completos AS
SELECT f.id, f.titulo, f.ano_lancamento, f.nota_imdb, d.nome AS diretor,
       GROUP_CONCAT(DISTINCT g.nome SEPARATOR ', ') AS generos,
       ROUND(AVG(a.nota),2) AS media_usuarios, COUNT(a.id) AS total_avaliacoes
FROM filmes f
LEFT JOIN diretores d ON d.id = f.diretor_id
LEFT JOIN filme_generos fg ON fg.filme_id = f.id
LEFT JOIN generos g ON g.id = fg.genero_id
LEFT JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY f.id, f.titulo, f.ano_lancamento, f.nota_imdb, d.nome;

CREATE VIEW vw_ranking_generos AS
SELECT g.nome AS genero, f.titulo, f.nota_imdb,
       ROW_NUMBER() OVER (PARTITION BY g.id ORDER BY f.nota_imdb DESC) AS posicao
FROM generos g
JOIN filme_generos fg ON fg.genero_id = g.id
JOIN filmes f ON f.id = fg.filme_id;

-- -------------------------------------------------------------
-- STORED PROCEDURE, FUNCTION e TRIGGERS
-- -------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_avaliar_filme(
    IN p_filme_id INT, IN p_usuario_id INT, IN p_nota TINYINT, IN p_comentario TEXT
)
BEGIN
    INSERT INTO avaliacoes (filme_id, usuario_id, nota, comentario)
    VALUES (p_filme_id, p_usuario_id, p_nota, p_comentario)
    ON DUPLICATE KEY UPDATE nota = p_nota, comentario = p_comentario, criado_em = NOW();
END //

CREATE FUNCTION fn_categoria_nota(p_nota DECIMAL(3,1)) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p_nota >= 8.8 THEN 'Obra-prima'
        WHEN p_nota >= 8.0 THEN 'Excelente'
        WHEN p_nota >= 7.0 THEN 'Bom'
        ELSE 'Regular'
    END;
END //

CREATE TRIGGER trg_avaliacao_valida
BEFORE INSERT ON avaliacoes
FOR EACH ROW
BEGIN
    IF NEW.nota NOT BETWEEN 1 AND 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nota deve ser entre 1 e 5';
    END IF;
END //

CREATE TRIGGER trg_filme_update
AFTER UPDATE ON filmes
FOR EACH ROW
BEGIN
    INSERT INTO log_filmes(filme_id, nota_antiga, nota_nova)
    VALUES (OLD.id, OLD.nota_imdb, NEW.nota_imdb);
END //

DELIMITER ;

-- =============================================================
-- CONSULTAS DE NEGÓCIO (Cap. 23 do README)
-- =============================================================

-- 23.1 Top 5 por média dos usuários
SELECT f.titulo, ROUND(AVG(a.nota),2) AS media_usuarios, COUNT(*) AS votos
FROM filmes f JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY f.id, f.titulo
HAVING COUNT(*) >= 2
ORDER BY media_usuarios DESC, votos DESC
LIMIT 5;

-- 23.2 Recomendação por gênero favorito do usuário 1
WITH genero_favorito AS (
    SELECT fg.genero_id, AVG(a.nota) AS media
    FROM avaliacoes a
    JOIN filme_generos fg ON fg.filme_id = a.filme_id
    WHERE a.usuario_id = 1
    GROUP BY fg.genero_id
    ORDER BY media DESC LIMIT 1
)
SELECT f.titulo, f.nota_imdb
FROM filmes f
JOIN filme_generos fg ON fg.filme_id = f.id
WHERE fg.genero_id = (SELECT genero_id FROM genero_favorito)
  AND f.id NOT IN (SELECT filme_id FROM avaliacoes WHERE usuario_id=1);

-- 23.3 Diretores com maior média (mín. 2 filmes)
SELECT d.nome, COUNT(f.id) AS filmes, ROUND(AVG(f.nota_imdb),2) AS media_imdb
FROM diretores d JOIN filmes f ON f.diretor_id = d.id
GROUP BY d.id
HAVING COUNT(f.id) >= 2
ORDER BY media_imdb DESC;

-- 23.4 Filmes sem avaliação
SELECT f.titulo FROM filmes f
LEFT JOIN avaliacoes a ON a.filme_id = f.id
WHERE a.id IS NULL;

-- 23.5 Ranking com Window Functions
SELECT titulo, nota_imdb,
       RANK() OVER (ORDER BY nota_imdb DESC) AS posicao_global,
       RANK() OVER (PARTITION BY diretor_id ORDER BY nota_imdb DESC) AS posicao_no_diretor
FROM filmes;

-- 23.6 Estatísticas por gênero
SELECT g.nome AS genero, COUNT(DISTINCT f.id) AS total_filmes,
       ROUND(AVG(f.nota_imdb),2) AS media_imdb,
       ROUND(AVG(a.nota),2) AS media_usuarios
FROM generos g
JOIN filme_generos fg ON fg.genero_id = g.id
JOIN filmes f ON f.id = fg.filme_id
LEFT JOIN avaliacoes a ON a.filme_id = f.id
GROUP BY g.nome;

-- Extra: busca full-text
SELECT titulo, sinopse FROM filmes WHERE MATCH(sinopse) AGAINST('sonho' IN NATURAL LANGUAGE MODE);

-- Extra: CTE + Window — top 2 por gênero
SELECT * FROM vw_ranking_generos WHERE posicao <= 2 ORDER BY genero, posicao;

-- Extra: CASE + Function
SELECT titulo, nota_imdb, fn_categoria_nota(nota_imdb) AS categoria FROM filmes;
