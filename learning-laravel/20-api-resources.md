# 20. API Resources e Paginação (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 20.1 Resource — transforma Model → JSON controlado (não retorna `hidden`)

```bash
php artisan make:resource PostResource
php artisan make:resource PostCollection --collection
```

```php
class PostResource extends JsonResource {
    public function toArray(Request $request): array {
        return [
            'id' => $this->id,
            'titulo' => $this->titulo,
            'resumo' => $this->resumo, // appends (cap. 11)
            'author' => new UserResource($this->whenLoaded('author')), // só se with('author')
            'tags' => TagResource::collection($this->whenLoaded('tags')),
            'links' => ['self' => route('api.posts.show', $this)],
            'published_at' => $this->publicado_em?->toIso8601String(),
        ];
    }
}
// Controller API
class PostApiController extends Controller {
    public function index() {
        return PostResource::collection(Post::with('author','tags')->paginate(10));
        // Paginate já vem com meta/links no JSON
    }
    public function show(Post $post) { return new PostResource($post->load('author','tags')); }
}
```

| Método | O que faz | Se esquecer |
|--------|-----------|-------------|
| `whenLoaded('author')` | Só inclui se `with('author')` | Sem `whenLoaded`, faz query N+1 escondida |
| `when($cond, fn()=>...)` | Condicional | — |

## 20.2 Paginação (comparado)

| Método | SQL | Quando usar | Blade/API |
|--------|-----|-------------|-----------|
| `paginate(10)` | `LIMIT 10 OFFSET 20` | Tabelas pequenas/médias | `$posts->links()` / `meta` + `links` |
| `simplePaginate(10)` | `LIMIT 11` (sem count) | Evita `COUNT(*)` lento | Sem total páginas |
| `cursorPaginate(10)` | `WHERE id > ? LIMIT 10` (keyset) | Tabelas enormes, `OFFSET` lento | `next_cursor` (sem página N) |

```php
Post::paginate(10); // ?page=2, Blade: {{ $posts->links() }}
Post::cursorPaginate(10); // ?cursor=eyJpZCI6MTB9
Post::apiPaginate() // custom scope que escolhe cursor vs offset
```

**Erro:**

```
Call to undefined method Illuminate\Database\Eloquent\Collection::paginate()
→ paginate só em Query Builder: Post::where(...)->paginate(), não Post::all()->paginate()
→ Correção: Post::query()->paginate()
```

---

⬅️ [Anterior: Middleware](./19-middleware-providers.md) | ➡️ [21. Filas e Eventos](./21-queues-events.md) | [Sumário](./README.md)
