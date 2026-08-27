# 02. O Projeto: Blog — ER e Chaves na Prática

> Parte do [Curso Completo de Laravel](./README.md)
> **Objetivo:** entender **chaves e relações** com dados visuais antes de `make:migration`.

## 2.1 Modelo ER (visual com dados)

```
users 1──N posts N──N tags (via post_tag)    posts 1──N comments N──1 users
posts N──1 categories
```

| Tabela | Papel | Campos chave | Relação | Exemplo |
|--------|-------|--------------|---------|---------|
| `users` | Autores | `id PK`, `email UNIQUE` | 1 user → N posts | `Ana (id=1)` → `Post 1, 3` |
| `categories` | Categoria | `id PK`, `nome UNIQUE` | 1 category → N posts | `Tech (id=1)` → 10 posts |
| `posts` | Centro | `user_id FK`, `category_id FK`, `slug UNIQUE` | — | `Post 1` pertence a `Ana` e `Tech` |
| `tags` | Etiquetas | `nome UNIQUE` | N:N com posts | `laravel, php` |
| `post_tag` | Ponte N:N | `post_id FK`, `tag_id FK`, **PK composta** `(post_id,tag_id)` | Liga `posts`↔`tags` | `(1,1)` = Post 1 é `laravel` |
| `comments` | Comentários | `post_id FK`, `user_id FK` | 1 post → N comments | `Post 1` ← 5 comentários |

> **Mesmo domínio do SQL** (`catalogo_filmes`): `diretores` vira `users`, `filmes` vira `posts`. Se fez SQL (`02-projeto-catalogo.md:1`), já conhece o ER.

### Dados visuais (como ficará no banco):

```
users                posts
┌────┬──────┐       ┌────┬─────────────┬─────────┬─────────────┐
│ id │ nome │       │ id │ titulo      │ user_id │ category_id │
│ PK │      │ FK    │ PK │             │ FK      │ FK          │
├────┼──────┤       ├────┼─────────────┼─────────┼─────────────┤
│ 1  │ Ana  │◄──────┤ 1  │ Intro       │ 1       │ 1           │
│ 2  │ Bruno│◄──────┤ 2  │ Laravel Tip │ 1       │ 1           │
└────┴──────┘       └────┴─────────────┴─────────┴─────────────┘
         ▲                       │
         └──── FOREIGN KEY ──────┘  (posts.user_id → users.id)
```

**O que acontece se violar?**

```sql
INSERT INTO posts (titulo, user_id) VALUES ('Erro', 99);
-- SQLSTATE[23000]: Foreign key violation — user 99 não existe (ver cap. 03.5)
```

## 2.2 Por que ponte `post_tag`? (1FN)

```
❌ Errado: posts.tags = 'php, laravel' — viola 1FN (SQL cap. 15), não dá para fazer
   Post::whereHas('tags', fn($q)=>$q->where('nome','laravel'))->get()
✅ Certo: post_tag (post_id, tag_id) — cada linha é um par, FK para ambos
   (1,1) Post 1 é laravel
   (1,2) Post 1 é php
   (2,1) Post 2 é laravel
```

> **Ponte N:N = tabela com 2 FKs + PK composta** — padrão que se repete em `filme_generos` (SQL), `post_tag` (Laravel), `role_user`, etc.

## 2.3 Chaves no Blog (tabela única)

| Constraint | Trava | Exemplo Blog | Erro se violar |
|------------|-------|--------------|----------------|
| `PRIMARY KEY` | Identidade única (CPF da linha) | `posts.id` | `Duplicate entry '1'` |
| `FOREIGN KEY` + `REFERENCES` | Só aceita valor que existe na outra tabela | `posts.user_id → users.id` | `Cannot add foreign key` / `Foreign key constraint fails` |
| `UNIQUE` | Não repete | `posts.slug`, `users.email` | `Duplicate entry 'ana@email.com'` |
| `NOT NULL` | Obrigatório | `posts.titulo` | `Field 'titulo' doesn't have a default value` |
| `DEFAULT` | Valor se omitir | `posts.ativo DEFAULT true` | Vira `NULL` se sem default |
| `CHECK` | Regra custom (SQL cap. 04) | MySQL: `CHECK (ativo IN (0,1))` | `Check constraint violated` |

## 2.4 Fluxo do curso com o Blog

```
03 Migrations (cria tabelas: users→categories→posts→post_tag→comments) // ordem FK importa!
   ↓
04 Seeders/Factories (popula: User::factory → Post::factory)
   ↓
05 Models (Post extends Model, $fillable) → 06 Relacionamentos (hasMany/belongsToMany)
   ↓
07 Accessors/Casts → 08 Scopes/Observers → 09 Mass Assignment → 10 Soft Deletes → 11-13 avançado
```

> Todo `php artisan make:model Post -m` cria **Model + Migration** do `posts` — prática desde o cap. 03.

---

⬅️ [Anterior: Introdução](./01-introducao.md) | ➡️ [03. Migrations](./03-migrations.md) | [Sumário](./README.md)
