# 14. Rotas e Controllers (dissecado)

> Parte do [Curso Completo de Laravel](./README.md) — Blog

## 14.1 Rotas — o garçom (Route)

```php
// routes/web.php
Route::get('/posts', [PostController::class, 'index'])->name('posts.index'); // 1. GET + 2. Controller@method + 3. nome
Route::post('/posts', [PostController::class, 'store']);
Route::get('/posts/{post}', [PostController::class, 'show']); // {post} = param
Route::resource('posts', PostController::class); // 7 rotas REST de uma vez
```

| Parte | O que faz | Se errar |
|-------|-----------|----------|
| `Route::get('/posts', ...)` | URL + verbo HTTP | `Route::get` sem `use App\Http\Controllers\PostController` → `Class not found` |
| `[PostController::class, 'index']` | Alvo | `Controller method not found` se método não existe |
| `->name('posts.index')` | Nome para `route('posts.index')` | Sem nome, `route()` falha |

**Ver rotas:** `php artisan route:list --path=posts`

## 14.2 Controller Resource (7 métodos)

```bash
php artisan make:controller PostController --resource
```

```php
class PostController extends Controller {
    public function index() { $posts = Post::with('category')->ativos()->paginate(10); return view('posts.index', compact('posts')); }
    public function show(Post $post) { return view('posts.show', compact('post')); } // 1. Implicit binding: {post} → Post $post
    public function store(Request $request) { $data = $request->validate([...]); Post::create($data); return redirect()->route('posts.index'); }
}
```

**Implicit binding:** `Route::get('/posts/{post}')` + `show(Post $post)` → Laravel faz `Post::findOrFail($id)` sozinho. Se `slug` em vez de `id`, `Post::getRouteKeyName() => 'slug'`.

---

⬅️ [Anterior: Projeto Lab](./13-projeto-blog-lab.md) | ➡️ [15. Blade](./15-blade-views.md) | [Sumário](./README.md)
