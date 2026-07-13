# Curso Completo de SQL --- Do Básico ao Avançado

Este material ensina **SQL do zero ao avançado**, com explicações claras
e exemplos práticos.

------------------------------------------------------------------------

## 1. O que é SQL

SQL (Structured Query Language) é a linguagem usada para manipular
bancos de dados relacionais.

------------------------------------------------------------------------

## 2. Criando Banco e Tabelas

``` sql
CREATE DATABASE sistema_vendas;
USE sistema_vendas;
```

``` sql
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    idade INT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

------------------------------------------------------------------------

## 3. Inserindo Dados (INSERT)

``` sql
INSERT INTO clientes (nome, email, idade)
VALUES ('Maria Oliveira', 'maria@email.com', 28);
```

------------------------------------------------------------------------

## 4. Consultando Dados (SELECT)

``` sql
SELECT nome, email FROM clientes;
```

``` sql
SELECT * FROM clientes WHERE idade > 30;
```

------------------------------------------------------------------------

## 5. Atualizando Dados (UPDATE)

``` sql
UPDATE clientes
SET idade = 29
WHERE id = 1;
```

------------------------------------------------------------------------

## 6. Removendo Dados (DELETE)

``` sql
DELETE FROM clientes WHERE id = 2;
```

------------------------------------------------------------------------

## 7. Funções de Agregação

``` sql
SELECT COUNT(*) FROM clientes;
SELECT AVG(idade) FROM clientes;
```

------------------------------------------------------------------------

## 8. Relacionamentos e JOIN

``` sql
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    valor DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

``` sql
SELECT c.nome, p.valor
FROM clientes c
INNER JOIN pedidos p ON p.cliente_id = c.id;
```

------------------------------------------------------------------------

## 9. Subqueries

``` sql
SELECT nome FROM clientes
WHERE id IN (
    SELECT cliente_id FROM pedidos WHERE valor > 500
);
```

------------------------------------------------------------------------

## 10. Índices

``` sql
CREATE INDEX idx_email ON clientes(email);
```

------------------------------------------------------------------------

## 11. Transações

``` sql
START TRANSACTION;
UPDATE contas SET saldo = saldo - 100 WHERE id = 1;
UPDATE contas SET saldo = saldo + 100 WHERE id = 2;
COMMIT;
```

------------------------------------------------------------------------

## 12. Views

``` sql
CREATE VIEW vw_clientes_pedidos AS
SELECT c.nome, p.valor
FROM clientes c
JOIN pedidos p ON p.cliente_id = c.id;
```

------------------------------------------------------------------------

## Boas Práticas

-   Nunca use UPDATE ou DELETE sem WHERE
-   Evite SELECT \*
-   Use índices com consciência
-   Utilize transações

------------------------------------------------------------------------

Autor: Ryan Oliveira
