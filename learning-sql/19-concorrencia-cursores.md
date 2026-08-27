# 19. Concorrência, Locks e Cursores

> Parte do [Curso Completo de SQL](./README.md)

## 19.1 Níveis de isolamento

| Nível | Lê não commitado | Leitura repetível | Previne phantom |
|-------|------------------|-------------------|-----------------|
| READ UNCOMMITTED | Sim (dirty read) | Não | Não |
| READ COMMITTED | Não | Não | Não |
| REPEATABLE READ (MySQL default) | Não | Sim | Parcial (gap lock) |
| SERIALIZABLE | Não | Sim | Sim |

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- sessão
START TRANSACTION;
SELECT * FROM filmes WHERE nota_imdb > 8;
-- Outra sessão tenta UPDATE — bloqueia ou não depende do nível
COMMIT;
```

## 19.2 Locks — `FOR UPDATE` vs `LOCK IN SHARE MODE`

```sql
-- Pessimista: trava linhas para atualizar
START TRANSACTION;
SELECT * FROM avaliacoes WHERE filme_id=1 FOR UPDATE; -- X lock, outros esperam
UPDATE avaliacoes SET nota=5 WHERE filme_id=1;
COMMIT;

-- Compartilhado: outros podem ler, não escrever
START TRANSACTION;
SELECT * FROM filmes WHERE id=1 LOCK IN SHARE MODE; -- S lock
-- PG: SELECT ... FOR SHARE
COMMIT;

-- Ver locks
SHOW ENGINE INNODB STATUS; -- MySQL
-- PG: SELECT * FROM pg_locks;
```

## 19.3 Deadlocks

```sql
-- Sessão A: lock filme 1, tenta filme 2
-- Sessão B: lock filme 2, tenta filme 1 → deadlock, MySQL aborta uma
-- Solução: sempre lock na mesma ordem (ORDER BY id)
START TRANSACTION;
SELECT * FROM filmes WHERE id IN (1,2) ORDER BY id FOR UPDATE;
COMMIT;
```

## 19.4 Cursores, HANDLERs e loops (complemento ao cap. 12)

```sql
DELIMITER //

CREATE PROCEDURE sp_recalc_media_todos()
BEGIN
    DECLARE v_filme_id INT;
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT id FROM filmes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_filme_id;
        IF v_done THEN LEAVE read_loop; END IF;

        UPDATE filmes SET nota_imdb = (
            SELECT ROUND(AVG(nota),1) FROM avaliacoes WHERE filme_id=v_filme_id
        ) WHERE id=v_filme_id;
    END LOOP;
    CLOSE cur;
END //

-- Loop com erro tratado
CREATE PROCEDURE sp_avalia_com_log(IN p_filme_id INT, IN p_nota TINYINT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL; -- re-lança erro
    END;
    START TRANSACTION;
    INSERT INTO avaliacoes (filme_id, usuario_id, nota) VALUES (p_filme_id, 1, p_nota);
    COMMIT;
END //

DELIMITER ;

CALL sp_recalc_media_todos();
```

> **Quando usar cursor:** raramente — `UPDATE ... JOIN` ou window function é 100x mais rápido. Cursor só para lógica procedural linha-a-linha inevitável.

---

⬅️ [Anterior: Particionamento](./18-particionamento.md) | [Próximo: Admin, Segurança e Performance](./20-admin-seguranca-performance.md) | [Sumário](./README.md)
