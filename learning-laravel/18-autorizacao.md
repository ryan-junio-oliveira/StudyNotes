# 18. Autorização — Gates e Policies (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 18.1 Gate (ação simples) vs Policy (model)

```php
// AppServiceProvider::boot()
Gate::define('update-post', fn(User $user, Post $post) => $user->id === $post->user_id);

// Policy
php artisan make:policy PostPolicy --model=Post
class PostPolicy { public function update(User $user, Post $post): bool { return $user->id === $post->user_id; } }
```

```php
// Controller
Gate::authorize('update-post', $post); // ou $this->authorize('update', $post);
@can('update', $post) <button>Editar</button> @endcan
```

| Gate | Policy |
|------|--------|
| Closure simples (`Gate::define`) | Classe por Model (`PostPolicy`) |
| `Gate::allows('update-post', $post)` | `$user->can('update', $post)` |

**Erro:** `403 This action is unauthorized` → Gate/Policy retornou `false`.

---

⬅️ [Anterior: Autenticação](./17-autenticacao.md) | ➡️ [19. Middleware e Providers](./19-middleware-providers.md) | [Sumário](./README.md)
