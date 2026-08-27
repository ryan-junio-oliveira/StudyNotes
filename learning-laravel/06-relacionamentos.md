# 06. Relacionamentos — HasMany, BelongsTo, N:N e Polimórficos

> Parte do [Curso Completo de Laravel](./README.md)

## 6.1 Visual do Blog

```
User 1──N Post N──N Tag (post_tag)
Post N──1 Category
Post 1──N Comment N──1 User
```

## 6.2 Tipos (tabela + quando usar)

| Tipo | Lado | Exemplo Blog | Método no Model |
|------|------|--------------|-----------------|
| 1:N | User→Posts | `User hasMany Post` | `User::posts()` |
| N:1 | Post→User | `Post belongsTo User` | `Post::author()` |
| N:N | Post↔Tag | `Post belongsToMany Tag` | `post_tag` ponte |
| 1:1 | Post→Meta | `Post hasOne PostMeta` | `hasOne`/`belongsTo` |
| Polimórfico | Comment em Post/Video | `morphMany` | `commentable` |

## 6.3 Código (Blog)

```php
// User.php
public function posts(): HasMany { return $this->hasMany(Post::class); }
// Post.php
public function author(): BelongsTo { return $this->belongsTo(User::class, 'user_id'); }
public function category(): BelongsTo { return $this->belongsTo(Category::class); }
public function tags(): BelongsToMany { return $this->belongsToMany(Tag::class); }
public function comments(): HasMany { return $this->hasMany(Comment::class); }

// Uso:
$post->author->name
$post->tags()->attach([1,2]); // N:N add
$post->tags()->sync([1,3]);   // sync
Post::with('author','tags')->get(); // eager loading (evita N+1)
```

**N+1:** sem `with`, cada `$post->author` faz query. Com `with`, 1 query só.

---

⬅️ [Anterior: Eloquent Básico](./05-eloquent-basico.md) | ➡️ [07. Accessors, Mutators e Casts](./07-accessors-casts.md) | [Sumário](./README.md)
