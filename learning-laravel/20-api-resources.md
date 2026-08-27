# 20. API Resources e Paginação

> Parte do [Curso Completo de Laravel](./README.md)

## 20.1 Resource (transforma Model → JSON)

```bash
php artisan make:resource PostResource
```

```php
class PostResource extends JsonResource {
    public function toArray(Request $request): array {
        return [
            'id' => $this->id,
            'titulo' => $this->titulo,
            'author' => new UserResource($this->whenLoaded('author')),
            'tags' => TagResource::collection($this->whenLoaded('tags')),
        ];
    }
}
// Controller API
return PostResource::collection(Post::with('author','tags')->paginate(10));
```

## 20.2 Paginação

```php
Post::paginate(10); // ?page=1, links() no Blade, meta no JSON
Post::cursorPaginate(10); // para tabelas grandes (sem OFFSET)
```

> **Erro:** `Call to undefined method paginate()` em Collection → paginate só em Query Builder (`Post::where(...)->paginate()`), não `Post::all()->paginate()`.

---

⬅️ [Anterior: Middleware](./19-middleware-providers.md) | ➡️ [21. Filas e Eventos](./21-queues-events.md) | [Sumário](./README.md)
