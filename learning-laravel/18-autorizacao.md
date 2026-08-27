# 18. Autorização — Gates e Policies (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)
> **Autenticação (cap. 17) = quem é você. Autorização (este) = pode fazer?**

## 18.1 Gate (ação simples) vs Policy (por Model)

|  | Gate | Policy |
|--|------|--------|
| Onde define | `AppServiceProvider::boot()` com `Gate::define` | `php artisan make:policy PostPolicy --model=Post` |
| Quando usar | Ação sem Model (`create-post`) ou global | Ação em Model (`update Post`) |
| Chama | `Gate::allows('update-post', $post)` | `$user->can('update', $post)` |

**Gate:**

```php
// AppServiceProvider::boot()
use Illuminate\Support\Facades\Gate;
Gate::define('update-post', function (User $user, Post $post): bool {
    return $user->id === $post->user_id; // só autor
});
// Controller
Gate::authorize('update-post', $post); // lança 403 se false
if (Gate::allows('update-post', $post)) { /* pode */ }
```

**Policy (recomendado para CRUD):**

```bash
php artisan make:policy PostPolicy --model=Post # 4 métodos: view, update, delete, create
```

```php
class PostPolicy {
    public function update(User $user, Post $post): bool { return $user->id === $post->user_id; }
    public function delete(User $user, Post $post): bool { return $user->id === $post->user_id || $user->is_admin; }
}
// AppServiceProvider: Gate::policy(Post::class, PostPolicy::class); // auto em Laravel 11+

// Controller
$this->authorize('update', $post); // usa PostPolicy@update
// ou
if ($user->cannot('update', $post)) abort(403);
```

## 18.2 No Blade e rotas

```blade
@can('update', $post) <a href="{{ route('posts.edit', $post) }}">Editar</a> @endcan
@cannot('update', $post) <p>Sem permissão</p> @endcannot
@canany(['update','delete'], $post) ... @endcanany
```

```php
Route::put('/posts/{post}', [PostController::class,'update'])->middleware('can:update,post');
```

**403 custom:**

```php
// PostPolicy::update() retorna false → AuthorizationException → 403
// Blade: resources/views/errors/403.blade.php
```

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `403 This action is unauthorized` | Gate/Policy retornou `false` | `Gate::before` para admin? `Gate::before(fn($user)=> $user->is_admin ? true : null);` |
| `Call to undefined method can()` sem `Authorizable` trait | `User` sem `HasRoles` | `User` já tem `Authorizable` por padrão |

> **Teste:** `actingAs($user)->put("/posts/{$post->id}", [...])->assertForbidden()` (Pest).

---

⬅️ [Anterior: Autenticação](./17-autenticacao.md) | ➡️ [19. Middleware e Providers](./19-middleware-providers.md) | [Sumário](./README.md)
