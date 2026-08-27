# 02. O Projeto: Catálogo de Filmes

> Parte do [Curso Completo de SQL](./README.md)

Vamos construir um sistema como IMDb simplificado. Todo capítulo usa essas tabelas — nada de `clientes/pedidos` isolados.

## Modelo ER

```
diretores 1──N filmes N──N generos (via filme_generos)
filmes N──N atores (via filme_atores)
filmes 1──N avaliacoes N──1 usuarios
```

**Entidades:**

| Tabela | Descrição |
|--------|-----------|
| `diretores` | Diretores dos filmes |
| `filmes` | Entidade central |
| `generos` | Gêneros (Ficção, Drama...) |
| `atores` | Elenco |
| `filme_generos` | N:N filmes ↔ gêneros |
| `filme_atores` | N:N filmes ↔ atores (+ personagem) |
| `usuarios` | Quem avalia |
| `avaliacoes` | Notas 1-5 por usuário/filme |

> O diagrama acima é o fio-condutor: do `CREATE TABLE` (cap. 03) até as consultas de recomendação (cap. 12).

---

## Próximo

➡️ [03. DDL — Criando Banco e Tabelas](./03-ddl-tabelas.md)

⬅️ [Anterior: Introdução](./01-introducao.md) | [Sumário](./README.md)
