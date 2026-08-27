# 08. Scopes e Observers (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 8.1 Query Scopes — filtros reutilizáveis (dissecado)

> **Scope = método `scopeX` no Model que vira `->x()` na query.** Evita repetir `where('ativo',1)` em todo lugar.

```php
// Post.php — definição
public function scopeAtivos(Builder $query): Builder {
    return $query->where('ativo', true); // 1. scope + nome + $query
}
public function scopePublicados(Builder $query): Builder {
    return $query->whereNotNull('publicado_em');
}
public function scopeDoAutor(Builder $query, int $userId): Builder {
    return $query->where('user_id', $userId); // 2. Com parâmetro
}
```

| Parte | O que significa | Se errar |
|-------|-----------------|----------|
| `scopeAtivos` | `scope` prefixo + `Ativos` → `ativos()` | `scopeativos` → `ativos()` não existe |
| `Builder $query` | Query que Laravel injeta | Sem typehint, ainda funciona mas sem autocomplete |
| `return $query->where(...)` | Encadeia | Sem `return`, scope não filtra |
| `DoAutor($query, int $userId)` | Scope com arg | Chama `Post::doAutor(1)` |

**Uso:**

```php
Post::ativos()->publicados()->get(); // SELECT * FROM posts WHERE ativo=1 AND publicado_em IS NOT NULL
Post::ativos()->where('user_id', 1)->get();
Post::doAutor(5)->ativos()->get(); // com param
```

> **Global Scope:** `addGlobalScope('ativos', fn($q)=>$q->where('ativo',1))` — filtra sempre (ex: multi-tenant). Remova com `withoutGlobalScope`.

## 8.2 Observers e Eventos (dissecado)

> **Observer = ouvinte que roda lógica quando Model muda (antes/depois de criar, etc).** Mantém `Post::creating` fora do Controller.

```bash
php artisan make:observer PostObserver --model=Post  # cria app/Observers/PostObserver.php
```

```php
// PostObserver.php — dissecado
public function creating(Post $post): void {
    // Antes de INSERT: gera slug se vazio
    if (empty($post->slug)) {
        $post->slug = Str::slug($post->titulo); // "Meu Post" → "meu-post"
    }
}
public function saving(Post $post): void {
    // Antes de INSERT ou UPDATE: garante resumo
    if (empty($post->resumo)) {
        $post->resumo = Str::limit($post->conteudo, 150);
    }
}
```

**Registro:**

```php
// AppServiceProvider::boot()
use App\Models\Post; use App\Observers\PostObserver;
Post::observe(PostObserver::class);
```

| Evento | Quando roda | Uso |
|--------|-------------|-----|
| `creating` / `created` | Antes/depois de INSERT | `slug` antes, notificação depois |
| `updating` / `updated` | Antes/depois de UPDATE | Auditoria |
| `saving` / `saved` | Antes/depois de INSERT ou UPDATE | Validação comum |
| `deleting` / `deleted` | Antes/depois de DELETE | Soft delete custom |
| `retrieved` | Ao buscar | Log |

**Sem Observer (no Controller):**

```php
// ❌ Controller inchado
$post->slug = Str::slug($request->titulo);
$post->save();
// ✅ Observer: Controller só $post->save(), slug vai automático
```

---

⬅️ [Anterior: Accessors](./07-accessors-casts.md) | ➡️ [09. Mass Assignment](./09-mass-assignment.md) | [Sumário](./README.md)
