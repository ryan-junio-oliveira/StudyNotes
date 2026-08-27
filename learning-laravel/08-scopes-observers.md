# 08. Scopes e Observers

> Parte do [Curso Completo de Laravel](./README.md)

## 8.1 Query Scopes (filtros reutilizáveis)

```php
// Post.php
public function scopeAtivos($query) { return $query->where('ativo', true); }
public function scopePublicados($query) { return $query->whereNotNull('publicado_em'); }

// Uso:
Post::ativos()->publicados()->get();
Post::ativos()->where('user_id', 1)->get();
```

## 8.2 Observers e Eventos

```bash
php artisan make:observer PostObserver --model=Post
```

```php
// PostObserver.php
public function creating(Post $post) { $post->slug = Str::slug($post->titulo); }
public function saving(Post $post) { if (empty($post->resumo)) $post->resumo = Str::limit($post->conteudo, 150); }

// AppServiceProvider::boot()
Post::observe(PostObserver::class);
```

| Evento | Quando |
|--------|--------|
| `creating`/`created` | Antes/depois de criar |
| `updating`/`updated` | Atualizar |
| `deleting`/`deleted` | Apagar |

> Observer = lógica de model fora do controller (slug, auditoria).

---

⬅️ [Anterior: Accessors](./07-accessors-casts.md) | ➡️ [09. Mass Assignment](./09-mass-assignment.md) | [Sumário](./README.md)
