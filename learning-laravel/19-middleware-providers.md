# 19. Middleware e Service Providers

> Parte do [Curso Completo de Laravel](./README.md)

## 19.1 Middleware — filtro de requisição

```bash
php artisan make:middleware EnsurePostAtivo
```

```php
public function handle(Request $request, Closure $next) {
    if (!$request->route('post')->ativo) abort(404);
    return $next($request);
}
// routes/web.php
Route::get('/posts/{post}', [PostController::class,'show'])->middleware('post.ativo');
```

| Tipo | Onde registra | Quando |
|------|---------------|--------|
| Global | `app/Http/Kernel.php $middleware` | Toda requisição |
| Grupo | `$middlewareGroups['web']` | `web`/`api` |
| Rota | `->middleware('auth')` | Só esta rota |

## 19.2 Service Provider

```bash
php artisan make:provider BlogServiceProvider
// app/Providers/AppServiceProvider::boot()
Post::observe(PostObserver::class);
Gate::define(...);
// View::share('categories', Category::all());
```

> **Erro:** `Target class [EnsurePostAtivo] does not exist` → registre em `Kernel.php` ou use FQCN `EnsurePostAtivo::class`.

---

⬅️ [Anterior: Autorização](./18-autorizacao.md) | ➡️ [20. API Resources](./20-api-resources.md) | [Sumário](./README.md)
