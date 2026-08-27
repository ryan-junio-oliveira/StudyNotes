# 14. Rotas e Controllers (dissecado para iniciantes)

> Parte do [Curso Completo de Laravel](./README.md) — Blog
> **Analogia:** Route = garçom que anota "mesa 5 quer /posts", Controller = chef que prepara.

## 14.1 Rotas — sintaxe peça a peça

```php
// routes/web.php
use App\Http\Controllers\PostController; // 1. Importar (sem use → Class not found)

Route::get('/posts', [PostController::class, 'index']) // 2. Verbo + URL + alvo
    ->name('posts.index'); // 3. Nome (para route('posts.index') no Blade)
```

| Parte | O que faz | Se errar |
|-------|-----------|----------|
| `Route::get('/posts', ...)` | Verbo `GET` + URL `/posts` | `GET` em form `POST` → `405 Method Not Allowed` |
| `[PostController::class, 'index']` | Classe + método | `Target class [PostController] does not exist` → `php artisan make:controller` |
| `->name('posts.index')` | Apelido para `route('posts.index')` | Sem nome, `route('posts.index')` falha com `Route not defined` |
| `{post}` em `/posts/{post}` | Parâmetro dinâmico | `Missing required parameter for [Route: posts.show]` → passe `route('posts.show', $post)` |

**Todos os verbos:**

```php
Route::get('/posts', [PostController::class,'index']);    // listar
Route::post('/posts', [PostController::class,'store']);   // criar
Route::get('/posts/{post}', [PostController::class,'show']); // ver 1
Route::put('/posts/{post}', [PostController::class,'update']); // atualizar
Route::delete('/posts/{post}', [PostController::class,'destroy']); // apagar
Route::resource('posts', PostController::class); // cria as 7 acima de uma vez!
```

**Ver rotas:** `php artisan route:list --path=posts` — mostra verbo, URI, nome, middleware.

## 14.2 Controller Resource — os 7 métodos (tabela)

```bash
php artisan make:controller PostController --resource # cria com 7 métodos vazios
php artisan make:controller PostController --api # sem create/edit (só API)
```

| Método | Verbo + URI | O que faz | Retorna |
|--------|-------------|-----------|---------|
| `index()` | `GET /posts` | Lista | `view('posts.index', ['posts'=>Post::paginate()])` |
| `create()` | `GET /posts/create` | Form criar | `view('posts.create')` |
| `store(Request $r)` | `POST /posts` | Salva | `Post::create($r->validated()); redirect()->route('posts.index')` |
| `show(Post $post)` | `GET /posts/{post}` | Ver 1 | `view('posts.show', compact('post'))` |
| `edit(Post $post)` | `GET /posts/{post}/edit` | Form editar | `view('posts.edit', ...)` |
| `update(Request $r, Post $post)` | `PUT /posts/{post}` | Atualiza | `$post->update($r->validated())` |
| `destroy(Post $post)` | `DELETE /posts/{post}` | Apaga | `$post->delete(); redirect...` |

```php
class PostController extends Controller {
    public function index() {
        $posts = Post::with('category','author')->ativos()->latest()->paginate(10);
        return view('posts.index', compact('posts'));
    }
    public function show(Post $post) { // Implicit binding (ver 14.3)
        return view('posts.show', compact('post'));
    }
    public function store(StorePostRequest $request) { // FormRequest valida (cap. 16)
        $post = Post::create($request->validated() + ['user_id'=>auth()->id()]);
        return redirect()->route('posts.show', $post)->with('success','Criado!');
    }
}
```

## 14.3 Implicit Binding (mágica dissecada)

```php
// Rota: Route::get('/posts/{post}', [PostController::class,'show']);
// Controller: show(Post $post)
// Laravel faz: Post::where('id', $post)->firstOrFail() sozinho!
```

- `{post}` (nome do param) deve bater com `Post $post` (nome da variável + typehint Model).
- Se `posts` usa `slug` em vez de `id`: no `Post` model, `public function getRouteKeyName(): string { return 'slug'; }` → `Route::get('/posts/{post:slug}')` também funciona.
- **Erro:** `No query results for model [App\Models\Post]` → `findOrFail` não achou `id` → 404 automático. Sem binding, você faria `Post::findOrFail($id)` manual.

**Agrupamento + middleware:**

```php
Route::middleware(['auth'])->group(function () {
    Route::resource('posts', PostController::class)->except(['index','show']);
});
Route::get('/dashboard', fn()=>view('dashboard'))->middleware(['auth','verified']);
```

> **Erro comum:** `419 Page Expired` → esqueceu `@csrf` no Blade `<form>` (cap. 15).

---

⬅️ [Anterior: Projeto Lab](./13-projeto-blog-lab.md) | ➡️ [15. Blade](./15-blade-views.md) | [Sumário](./README.md)
