# 19. Middleware e Service Providers (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 19.1 Middleware — filtro de requisição (analogia porteiro)

```
Request → [Middleware A → B → C] → Controller → Response → [C → B → A] → Browser
            antes                    depois
```

```bash
php artisan make:middleware EnsurePostAtivo
```

```php
class EnsurePostAtivo {
    public function handle(Request $request, Closure $next): Response {
        // Antes do Controller
        $post = $request->route('post'); // Post do binding (cap. 14)
        if (!$post->ativo) abort(404, 'Post não publicado');
        $response = $next($request); // passa adiante
        // Depois do Controller (pode modificar $response)
        $response->headers->set('X-Post-Status', 'ativo');
        return $response;
    }
}
```

**Registro:**

```php
// app/Http/Kernel.php (Laravel 10) ou bootstrap/app.php (Laravel 11)
protected $middleware = [ /* global: toda requisição */ ];
protected $middlewareGroups = ['web' => [...], 'api' => [...]];
protected $routeMiddleware = ['post.ativo' => EnsurePostAtivo::class]; // alias

// Uso
Route::get('/posts/{post}', [PostController::class,'show'])->middleware('post.ativo');
// ou grupo
Route::middleware(['auth','post.ativo'])->group(fn()=> Route::resource('posts', PostController::class));
```

| Tipo | Onde registra | Quando | Exemplo |
|------|---------------|--------|---------|
| **Global** | `$middleware` | Toda requisição | `TrimStrings`, `TrustProxies` |
| **Grupo** | `$middlewareGroups['web']` | Grupo `web`/`api` | `auth`, `throttle` |
| **Rota** | `->middleware('post.ativo')` | Só esta rota | `EnsurePostAtivo` |
| **Terminable** | `terminate()` | Depois da resposta enviada | Log |

**Erro:** `Target class [EnsurePostAtivo] does not exist` → registrou alias mas usou FQCN? Use `EnsurePostAtivo::class` ou `post.ativo`.

## 19.2 Service Provider — boot da aplicação

```bash
php artisan make:provider BlogServiceProvider
// config/app.php 'providers' => [BlogServiceProvider::class]
```

```php
class BlogServiceProvider extends ServiceProvider {
    public function register(): void {} // bind container
    public function boot(): void {
        Post::observe(PostObserver::class); // cap. 08
        Gate::define('update-post', ...); // cap. 18
        View::share('categories', Category::all()); // disponível em todo Blade
        Blade::component('alert', Alert::class); // componente
    }
}
```

> `AppServiceProvider::boot()` já serve para maioria — `BlogServiceProvider` só se crescer.

---

⬅️ [Anterior: Autorização](./18-autorizacao.md) | ➡️ [20. API Resources](./20-api-resources.md) | [Sumário](./README.md)
