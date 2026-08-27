# 05. Eloquent Básico — Models

> Parte do [Curso Completo de Laravel](./README.md)

## 5.1 Criando Models (sintaxe dissecada)

```bash
php artisan make:model Post              # só Model
php artisan make:model Post -mcr         # -m migration, -c controller, -r resource
php artisan make:model Post -mf          # + factory
```

```php
class Post extends Model {
    protected $table = 'posts';           // 1. Tabela (padrão: plural snake_case)
    protected $primaryKey = 'codigo';     // 2. PK se não for id
    public $incrementing = false;         // 3. Se PK não for AUTO_INCREMENT
    protected $keyType = 'string';        // 4. Se PK for UUID
    public $timestamps = true;            // 5. created_at/updated_at (false desativa)
    protected $fillable = ['titulo','conteudo']; // 6. Mass assignment (cap. 10)
    protected $hidden = ['senha'];        // 7. Oculta no JSON
    protected $casts = ['ativo' => 'boolean']; // 8. Casting (cap. 07)
}
```

| Atributo | Padrão | Quando mudar |
|----------|--------|--------------|
| `$table` | `posts` (plural do Model) | Tabela legada `tbl_post` |
| `$primaryKey` | `id` | PK `codigo` |
| `$timestamps` | `true` | Tabela sem `created_at` |

**Convenção:** `Post` → `posts`, `Category` → `categories`. Siga, evita `protected $table`.

## 5.2 CRUD básico

```php
Post::create(['titulo' => 'Olá', 'conteudo' => '...', 'user_id' => 1]);
$post = Post::find(1); // por PK
$posts = Post::where('ativo', true)->orderBy('created_at')->get();
$post->update(['titulo' => 'Novo']);
$post->delete();
```

---

⬅️ [Anterior: Seeders](./04-seeders-factories.md) | ➡️ [06. Relacionamentos](./06-relacionamentos.md) | [Sumário](./README.md)
