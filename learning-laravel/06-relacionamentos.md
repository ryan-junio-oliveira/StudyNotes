# 06. Relacionamentos — HasMany, BelongsTo, N:N e Polimórficos (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 6.1 Visual do Blog (com FK)

```
User 1──N Post N──N Tag (via post_tag)
  PK id ── FK user_id
Post N──1 Category
  FK category_id ── PK id (categories)
Post 1──N Comment N──1 User
  PK id ── FK post_id
```

> **Regra:** `hasMany` fica no lado **1**, `belongsTo` no lado **N** (onde está a FK).

## 6.2 Tipos (tabela dissecada)

| Tipo | Lado FK | Exemplo Blog | Método no Model | Onde está FK? |
|------|---------|--------------|-----------------|---------------|
| **1:N** | N | `User` tem N `Post` | `User::hasMany(Post::class)` | `posts.user_id` |
| **N:1** | N | `Post` pertence a `User` | `Post::belongsTo(User::class, 'user_id')` | `posts.user_id` |
| **N:N** | Ponte | `Post` ↔ `Tag` | `Post::belongsToMany(Tag::class)` | `post_tag` (post_id, tag_id) |
| **1:1** | N (com unique) | `Post` tem 1 `PostMeta` | `hasOne`/`belongsTo` | `post_meta.post_id` |
| **Polimórfico** | `morph` | `Comment` em `Post` ou `Video` | `morphMany`/`morphTo` | `comments.commentable_id` + `commentable_type` |

**Convenção vs explícito:**

```php
// Convenção: belongsTo(User::class) → FK user_id → users.id
public function author(): BelongsTo { return $this->belongsTo(User::class); } // tenta user_id

// Explícito: FK fora da convenção
public function author(): BelongsTo { return $this->belongsTo(User::class, 'autor_id', 'id'); }
// segundo arg = FK local, terceiro = PK do pai
```

## 6.3 Código Blog (dissecado)

```php
// User.php — 1 User tem N Posts
public function posts(): HasMany {
    return $this->hasMany(Post::class); // hasMany(Post, 'user_id', 'id') — padrão já é user_id
}

// Post.php — N Posts pertencem a 1 User/Category, N:N Tags, 1:N Comments
public function author(): BelongsTo {
    return $this->belongsTo(User::class, 'user_id'); // belongsTo(User, FK local, PK pai)
}
public function category(): BelongsTo {
    return $this->belongsTo(Category::class);
}
public function tags(): BelongsToMany {
    return $this->belongsToMany(Tag::class); // ponte post_tag (alfabética: post_tag, não tag_post)
    // com pivot extra: ->withPivot('adicionado_por')->withTimestamps()
}
public function comments(): HasMany {
    return $this->hasMany(Comment::class);
}
```

**Uso:**

```php
$post->author->name; // lazy: 1 query para post + 1 para author (N+1 se em loop)
$post->tags()->attach([1,2]); // N:N adiciona (insert em post_tag)
$post->tags()->detach([1]);   // remove
$post->tags()->sync([1,3]);   // deixa só 1 e 3 (sync = exatamente)
```

## 6.4 Eager Loading e N+1 (o erro #1 de performance)

```php
// ❌ N+1: 1 query para 10 posts + 10 queries para author = 11 queries
$posts = Post::all();
foreach ($posts as $post) { echo $post->author->name; }

// ✅ Eager: 2 queries (posts + authors)
$posts = Post::with('author','tags','category')->get();
foreach ($posts as $post) { echo $post->author->name; } // já carregado

// Debug: ver queries
DB::enableQueryLog(); Post::with('author')->get(); dd(DB::getQueryLog());
```

| Sem `with` | Com `with` |
|------------|------------|
| 11 queries para 10 posts | 2 queries |
| Lento com paginação | Rápido |

**Erro comum:**

```
SQLSTATE[42S22]: Unknown column 'post.user_id'
→ Model Post com belongsTo(User::class) mas FK é author_id — especifique segundo arg
```

---

⬅️ [Anterior: Eloquent Básico](./05-eloquent-basico.md) | ➡️ [07. Accessors, Mutators e Casts](./07-accessors-casts.md) | [Sumário](./README.md)
