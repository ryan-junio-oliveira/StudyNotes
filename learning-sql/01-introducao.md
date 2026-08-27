# 01. Introdução — Começando do Zero

> Parte do [Curso Completo de SQL](./README.md) — Projeto **Catálogo de Filmes**
> **Para quem nunca viu um banco de dados na vida.** Se você já programa, pule para [02. Projeto](./02-projeto-catalogo.md).

## 1.1 O que é um banco de dados?

Imagine uma **planilha de Excel** gigante:

- **Banco de dados** = o arquivo `.xlsx` inteiro
- **Tabela** = cada aba (ex: `filmes`, `diretores`)
- **Coluna** = cada campo (ex: `titulo`, `ano_lancamento`)
- **Linha (registro)** = cada entrada (ex: um filme)
- **Célula** = o valor em si

```
Banco: catalogo_filmes
 └─ Tabela: filmes
     ├─ Colunas: id | titulo      | ano_lancamento | diretor_id
     └─ Linhas:  1  | Inception   | 2010           | 1
                2  | Interstellar| 2014           | 1
```

**SGBD** (Sistema Gerenciador de Banco de Dados) é o programa que guarda e organiza tudo — MySQL, PostgreSQL, SQL Server. Você manda comandos **SQL** e ele responde.

> **Analogia:** Banco = biblioteca, Tabela = estante, Linha = livro, Coluna = informação do livro (título, autor).

## 1.2 Por que "relacional"?

Banco **relacional** guarda dados em tabelas que se **relacionam**. Exemplo:

- `filmes.diretor_id = 1` **aponta para** `diretores.id = 1` (Nolan)
- Sem relacional, você repetiria `"Christopher Nolan"` em todo filme — desperdício e erro.

```
diretores                filmes
┌────┬──────────────┐   ┌────┬──────────────┬────────────┐
│ id │ nome         │   │ id │ titulo       │ diretor_id │
├────┼──────────────┤   ├────┼──────────────┼────────────┤
│ 1  │ Nolan        │◄──┤ 1  │ Inception    │ 1          │
│ 2  │ Villeneuve   │◄──┤ 2  │ Dune         │ 2          │
└────┴──────────────┘   └────┴──────────────┴────────────┘
         ▲                        │
         └──── FOREIGN KEY ───────┘
```

Isso é **chave estrangeira** (veremos no cap. 02).

## 1.3 O que é SQL?

SQL = *Structured Query Language* (Linguagem de Consulta Estruturada). É como você **conversa** com o SGBD:

```sql
-- "Me mostre todos os filmes de 2010"
SELECT titulo FROM filmes WHERE ano_lancamento = 2010;
```

Divide-se em 5 grupos:

| Categoria | Sigla | O que faz | Comandos |
|-----------|-------|-----------|----------|
| Definição | **DDL** | Criar/alterar estrutura | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| Manipulação | **DML** | Inserir/alterar/apagar dados | `INSERT`, `UPDATE`, `DELETE` |
| Consulta | **DQL** | Buscar dados | `SELECT` (o mais usado!) |
| Transação | **TCL** | Garantir segurança em operações | `START TRANSACTION`, `COMMIT`, `ROLLBACK` |
| Controle | **DCL** | Permissões | `GRANT`, `REVOKE` |

> Você **não precisa decorar** — vai usar naturalmente ao longo do curso.

## 1.4 Glossário mínimo (volte aqui quando esquecer)

| Termo | Significado simples | Exemplo |
|-------|---------------------|---------|
| **PRIMARY KEY** | Identidade única da linha — como CPF | `diretores.id = 1` |
| **FOREIGN KEY** | Aponta para PRIMARY KEY de outra tabela | `filmes.diretor_id → diretores.id` |
| **UNIQUE** | Não deixa repetir | `usuarios.email` |
| **NOT NULL** | Campo obrigatório | `filmes.titulo` não pode ser vazio |
| **CHECK** | Regra custom | `nota_imdb BETWEEN 0 AND 10` |
| **DEFAULT** | Valor padrão se não informar | `orcamento DEFAULT 0` |
| **REFERENCES** | De onde a FOREIGN KEY vem | `REFERENCES diretores(id)` |
| **INDEX** | Atalho para busca rápida — como índice de livro | `idx_filmes_titulo` |
| **NULL** | Ausência de valor (não é zero nem `""`) | `sinopse = NULL` |

> Todos serão **dissecados com exemplos visuais** nos caps. 02–04.

## 1.5 Como executar SQL

**Opção A — Docker do curso (recomendada):**

```bash
cd learning-docker
cp .env.example .env   # cria senha
docker-compose up -d   # sobe MySQL 8
docker-compose exec mysql mysql -u root -p -e "SHOW DATABASES;"
```

**Opção B — MySQL local, DBeaver, Workbench, VS Code (SQLTools):** qualquer um serve.

Teste seu primeiro comando:

```sql
SELECT 'Olá, SQL!' AS mensagem;
-- Retorna: Olá, SQL!
```

---

## Como usar este curso

1. Leia em ordem — cada capítulo usa o mesmo banco `catalogo_filmes`.
2. **Execute** cada bloco — ler sem praticar não fixa.
3. Errou? Leia a mensagem de erro — ela ensina (veremos erros comuns em cada capítulo).
4. Ao final, importe [`projeto-catalogo-filmes.sql`](./projeto-catalogo-filmes.sql) e terá o projeto completo.

## Próximo

➡️ [02. O Projeto: Catálogo de Filmes — Entendendo PK, FK e Relacionamentos](./02-projeto-catalogo.md)

⬅️ [Voltar ao Sumário](./README.md)
