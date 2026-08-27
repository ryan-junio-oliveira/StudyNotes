# 16. Validação — FormRequest (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 16.1 Por que não `$request->all()` direto?

```php
// ❌ sem validação: slug duplicado, titulo vazio passa
Post::create($request->all());

// ✅ validação
$validated = $request->validate([
    'titulo' => 'required|string|max:150|unique:posts,slug',
    'conteudo' => 'required|min:10',
    'category_id' => 'nullable|exists:categories,id',
]);
Post::create($validated);
```

| Regra | O que valida | Mensagem se falhar |
|-------|--------------|-------------------|
| `required` | Obrigatório | `The titulo field is required.` |
| `max:150` | Tamanho | `The titulo must not be greater than 150` |
| `unique:posts,slug` | Não repete | `The slug has already been taken.` |
| `exists:categories,id` | FK existe | `The selected category is invalid.` |

## 16.2 FormRequest (recomendado)

```bash
php artisan make:request StorePostRequest
```

```php
class StorePostRequest extends FormRequest {
    public function authorize(): bool { return true; } // ou Gate (cap. 18)
    public function rules(): array {
        return ['titulo' => 'required|max:150', 'conteudo' => 'required'];
    }
    public function messages(): array { return ['titulo.required' => 'Título obrigatório']; }
}
// Controller
public function store(StorePostRequest $request) { Post::create($request->validated()); }
```

> **Erro:** `422 Unprocessable` = validação falhou — veja `session('errors')` no Blade: `@error('titulo') {{ $message }} @enderror`.

---

⬅️ [Anterior: Blade](./15-blade-views.md) | ➡️ [17. Autenticação](./17-autenticacao.md) | [Sumário](./README.md)
