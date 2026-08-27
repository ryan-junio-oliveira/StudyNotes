# 11. Collections, Casts Custom e Avançados (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 11.1 Eloquent Collection vs Collection base

`Post::all()` não retorna array, retorna `Eloquent\Collection` (métodos `filter`, `map`, `groupBy`, etc).

```php
$posts = Post::all(); // Collection
$posts->filter(fn($p) => $p->ativo); // só ativos
$posts->pluck('titulo'); // só títulos
$posts->groupBy('category_id'); // agrupa
$posts->sortBy('created_at');
```

## 11.2 Custom Collection

```php
class PostCollection extends \Illuminate\Database\Eloquent\Collection {
    public function publicados() { return $this->filter->ativo; } // ou $this->filter(fn($p)=>$p->ativo)
    public function rss() { return $this->map(fn($p) => "<item>{$p->titulo}</item>"); }
}
class Post extends Model {
    public function newCollection(array $models = []) { return new PostCollection($models); }
}
Post::all()->publicados()->rss();
```

## 11.3 `withDefault`, `replicate`, `touches` (tabela)

| Recurso | O que faz | Exemplo |
|---------|-----------|---------|
| `withDefault()` | `belongsTo` sem pai não dá `null` → dá objeto padrão | `$post->author()->withDefault(['name'=>'Anônimo'])->name` |
| `replicate()` | Clona model sem PK/timestamps | `$copy = $post->replicate(); $copy->titulo .= ' (cópia)'; $copy->save();` |
| `touches` | Ao salvar filho, pai `updated_at` atualiza | `class Comment extends Model { protected $touches = ['post']; }` |

## 11.4 `appends`, `loadMissing`, `firstOrCreate`

```php
// appends: atributo calculado sempre no JSON
protected $appends = ['resumo']; // include no toJson()
public function getResumoAttribute(): string { return Str::limit($this->conteudo, 100); }
$post->resumo; // "Lorem ipsum..." (não é coluna, é accessor + appends)

// loadMissing: eager load tardio (evita N+1 depois)
$post = Post::first();
$post->loadMissing('tags','author'); // só carrega se ainda não carregou

// firstOrCreate / updateOrCreate
Post::firstOrCreate(['slug' => $slug], ['titulo' => $titulo]); // busca ou cria
Post::updateOrCreate(['slug' => $slug], ['titulo' => $titulo]); // busca, atualiza ou cria
User::firstOrCreate(['email' => $email], ['name' => $nome]); // padrão User
```

---

⬅️ [Anterior: Soft Deletes](./10-soft-deletes.md) | ➡️ [12. Boas Práticas](./12-boas-praticas.md) | [Sumário](./README.md)
