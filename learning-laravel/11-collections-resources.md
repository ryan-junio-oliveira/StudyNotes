# 11. Collections, Casts Custom e Avançados

> Parte do [Curso Completo de Laravel](./README.md)

## 11.1 Custom Collection

```php
class PostCollection extends Collection {
    public function publicados() { return $this->filter->ativo; }
}
class Post extends Model {
    public function newCollection(array $models = []) { return new PostCollection($models); }
}
Post::all()->publicados();
```

## 11.2 `withDefault`, `replicate`, `touches`

```php
$post->author()->withDefault(['name' => 'Anônimo']); // belongsTo sem autor
$copy = $post->replicate(); $copy->save(); // clona

class Comment extends Model { protected $touches = ['post']; } // ao comentar, post.updated_at atualiza
```

## 11.3 `appends`, `loadMissing`, `firstOrCreate`

```php
protected $appends = ['resumo']; // sempre no JSON
public function getResumoAttribute() { return Str::limit($this->conteudo, 100); }

$post->loadMissing('tags'); // eager load tardio
Post::firstOrCreate(['slug' => $slug], ['titulo' => $titulo]);
Post::updateOrCreate(['slug' => $slug], ['titulo' => $titulo]);
```

---

⬅️ [Anterior: Soft Deletes](./10-soft-deletes.md) | ➡️ [12. Boas Práticas](./12-boas-praticas.md) | [Sumário](./README.md)
