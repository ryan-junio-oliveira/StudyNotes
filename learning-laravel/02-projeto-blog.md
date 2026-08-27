# 02. O Projeto: Blog — ER e Fio-Condutor

> Parte do [Curso Completo de Laravel](./README.md)

## 2.1 Modelo ER do Blog

```
users 1──N posts N──N tags (via post_tag)
posts N──1 categories
posts 1──N comments N──1 users
```

| Tabela | Papel | Campos chave | Relação |
|--------|-------|--------------|---------|
| `users` | Autores/leitores | `id`, `email UNIQUE` | 1 user → N posts |
| `categories` | Categoria | `id`, `nome UNIQUE` | 1 category → N posts |
| `posts` | Centro | `user_id FK`, `category_id FK`, `slug UNIQUE` | N posts → N tags |
| `tags` | Etiquetas | `nome UNIQUE` | N tags → N posts (ponte `post_tag`) |
| `post_tag` | Ponte N:N | `post_id`, `tag_id` PK composta | — |
| `comments` | Comentários | `post_id FK`, `user_id FK` | 1 post → N comments |

> **Mesmo domínio do SQL** (`catalogo_filmes` → `blog`): `diretores` vira `users`, `filmes` vira `posts`. Se fez SQL, já conhece o ER.

## 2.2 Por que ponte `post_tag`?

```
❌ Errado: posts.tags = 'php, laravel' — viola 1FN, não dá para fazer whereHas('tags')
✅ Certo: post_tag (post_id, tag_id) — cada linha é um par, FK para ambos
```

## 2.3 Fluxo do curso com o Blog

```
03 Migrations (cria tabelas) → 04 Seeders/Factories (popula) → 05 Models → 06 Relacionamentos
→ 07 Accessors/Casts → 08 Scopes → 09 Observers → 10 Mass Assignment → 11 Soft Deletes → 12-14 avançado
```

Todo `php artisan make:model Post -m` cria **Model + Migration** do `posts` — prática desde o cap. 03.

---

⬅️ [Anterior: Introdução](./01-introducao.md) | ➡️ [03. Migrations](./03-migrations.md) | [Sumário](./README.md)
