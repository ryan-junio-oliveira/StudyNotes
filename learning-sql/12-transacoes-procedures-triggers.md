# 12. Transações, Procedures, Functions, Triggers e DCL

> Parte do [Curso Completo de SQL](./README.md)

## 12.1 Transações — ACID

```sql
-- ACID: Atomicidade, Consistência, Isolamento, Durabilidade
START TRANSACTION;

INSERT INTO usuarios (nome, email) VALUES ('Carla', 'carla@email.com');
INSERT INTO avaliacoes (filme_id, usuario_id, nota) VALUES (1, LAST_INSERT_ID(), 5);

-- SAVEPOINT
SAVEPOINT antes_erro;
-- ... operação arriscada ...
-- ROLLBACK TO SAVEPOINT antes_erro; -- desfaz só parte
COMMIT; -- ou ROLLBACK;

-- Níveis de isolamento (concorrência)
-- READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ (MySQL default) | SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```

**Exemplo real — atomico:**

```sql
START TRANSACTION;
UPDATE avaliacoes SET nota = 4 WHERE id = 1;
UPDATE filmes SET nota_imdb = (SELECT AVG(nota) FROM avaliacoes WHERE filme_id=1) WHERE id=1;
COMMIT;
```

## 12.2 Stored Procedures, Functions e Triggers

### Procedure

```sql
DELIMITER //

CREATE PROCEDURE sp_avaliar_filme(
    IN p_filme_id INT, IN p_usuario_id INT, IN p_nota TINYINT, IN p_comentario TEXT
)
BEGIN
    INSERT INTO avaliacoes (filme_id, usuario_id, nota, comentario)
    VALUES (p_filme_id, p_usuario_id, p_nota, p_comentario)
    ON DUPLICATE KEY UPDATE nota = p_nota, comentario = p_comentario, criado_em = NOW();
END //

DELIMITER ;

CALL sp_avaliar_filme(1, 1, 5, 'Reassisti, ainda perfeito!');
```

### Function

```sql
DELIMITER //

CREATE FUNCTION fn_categoria_nota(p_nota DECIMAL(3,1)) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p_nota >= 8.8 THEN 'Obra-prima'
        WHEN p_nota >= 8.0 THEN 'Excelente'
        ELSE 'Bom'
    END;
END //

DELIMITER ;

SELECT titulo, fn_categoria_nota(nota_imdb) FROM filmes;
```

### Trigger

```sql
DELIMITER //

CREATE TRIGGER trg_avaliacao_valida
BEFORE INSERT ON avaliacoes
FOR EACH ROW
BEGIN
    IF NEW.nota NOT BETWEEN 1 AND 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nota deve ser entre 1 e 5';
    END IF;
END //

-- Trigger de auditoria
CREATE TRIGGER trg_filme_update
AFTER UPDATE ON filmes
FOR EACH ROW
BEGIN
    INSERT INTO log_filmes(filme_id, nota_antiga, nota_nova, alterado_em)
    VALUES (OLD.id, OLD.nota_imdb, NEW.nota_imdb, NOW());
END //

DELIMITER ;
```

## 12.3 DCL — Controle de Acesso

```sql
CREATE USER 'app_leitura'@'%' IDENTIFIED BY 'senha_forte';
GRANT SELECT ON catalogo_filmes.* TO 'app_leitura'@'%';

CREATE USER 'app_admin'@'%' IDENTIFIED BY 'senha_forte';
GRANT ALL PRIVILEGES ON catalogo_filmes.* TO 'app_admin'@'%';

REVOKE DELETE ON catalogo_filmes.* FROM 'app_leitura'@'%';
DROP USER 'app_leitura'@'%';

-- Ver permissões
SHOW GRANTS FOR 'app_admin'@'%';
```

---

⬅️ [Anterior: Índices e Views](./11-indices-views.md) | [Próximo: Projeto Final](./13-projeto-final.md) | [Sumário](./README.md)
