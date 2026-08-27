# 16. Validação — FormRequest (dissecado para iniciantes)

> Parte do [Curso Completo de Laravel](./README.md)
> **Validação = porteiro que barra dado ruim antes de chegar no Model.** Sem ela, `titulo = ""` ou `slug` duplicado quebra o banco com `SQLSTATE[23000]`.

## 16.1 Sem vs com validação (por que não `$request->all()`)

```php
// ❌ sem validação: titulo vazio, slug duplicado, FK fantasma passam
Post::create($request->all());
// → Duplicate entry 'meu-post' ou Field 'titulo' doesn't have a default value

// ✅ com validate() — barra antes do banco
$validated = $request->validate([
    'titulo' => 'required|string|max:150|unique:posts,slug',
    'conteudo' => 'required|min:10',
    'category_id' => 'nullable|exists:categories,id',
    'publicado_em' => 'nullable|date',
]);
Post::create($validated); // só entra o validado
```

| Parte | O que faz | Se errar |
|-------|-----------|----------|
| `'required'` | Obrigatório | `The titulo field is required.` |
| `'string\|max:150'` | Texto até 150 | `The titulo must not be greater than 150` |
| `'unique:posts,slug'` | Não repete `slug` em `posts` | `The slug has already been taken.` |
| `'exists:categories,id'` | `category_id` existe em `categories.id` | `The selected category is invalid.` (FK) |
| `'nullable\|date'` | Pode ser `null` ou data | `The publicado em is not a valid date.` |

**O que `validate()` faz:** se falhar, Laravel **não executa** `Post::create` — retorna `422` + `session('errors')` com `old()` no Blade.

```blade
@error('titulo') <span class="error">{{ $message }}</span> @enderror
<input value="{{ old('titulo') }}"> {{-- mantém digitado --}}
```

## 16.2 FormRequest — validação fora do Controller (recomendado)

> Controller magro: `store()` só faz `Post::create($request->validated())`.

```bash
php artisan make:request StorePostRequest # cria app/Http/Requests/StorePostRequest.php
```

```php
class StorePostRequest extends FormRequest {
    public function authorize(): bool {
        return true; // true = qualquer logado pode; ou Gate: return $this->user()->can('create', Post::class);
    }
    public function rules(): array {
        return [
            'titulo' => ['required','string','max:150','unique:posts,slug'],
            'conteudo' => ['required','min:10'],
            'category_id' => ['nullable','exists:categories,id'],
        ];
    }
    public function messages(): array {
        return ['titulo.required' => 'Título é obrigatório', 'titulo.unique' => 'Slug já existe'];
    }
    // Opcional: prepareForValidation() para trim/slug antes
    protected function prepareForValidation(): void {
        $this->merge(['slug' => Str::slug($this->titulo)]);
    }
}
// Controller
public function store(StorePostRequest $request) {
    $post = Post::create($request->validated() + ['user_id' => auth()->id()]);
    return redirect()->route('posts.show', $post);
}
```

| Método | Quando roda | Se retornar `false` |
|--------|-------------|---------------------|
| `authorize()` | Antes de `rules()` | `403 Forbidden` |
| `rules()` | Valida | `422` + `errors` |
| `messages()` | Customiza mensagem | Usa padrão `The ... field is required.` |
| `prepareForValidation()` | Antes de validar | Útil para normalizar `slug` |

**Bail e condicionais:**

```php
'titulo' => 'bail|required|unique:posts,slug|max:150' // bail = para no primeiro erro
'publicado_em' => 'required_if:ativo,1|date' // só se ativo
```

> **Erro:** `422 Unprocessable Entity` = validação falhou — veja `session('errors')` no Blade com `@error('campo')`.

---

⬅️ [Anterior: Blade](./15-blade-views.md) | ➡️ [17. Autenticação](./17-autenticacao.md) | [Sumário](./README.md)
