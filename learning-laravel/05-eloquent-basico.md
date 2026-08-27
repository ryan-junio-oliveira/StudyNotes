# 05. Eloquent Básico — Models (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)
> **Eloquent = tradutor tabela ↔ classe.** `Post` (classe) ↔ `posts` (tabela), `Post::find(1)` ↔ `SELECT * FROM posts WHERE id=1`.

## 5.1 Criando Models (sintaxe dissecada)

```bash
php artisan make:model Post              # só Model app/Models/Post.php
php artisan make:model Post -m           # + migration create_posts_table
php artisan make:model Post -mcr         # -m migration, -c controller, -r resource (index/show...)
php artisan make:model Post -a           # tudo (model, migration, seeder, factory, controller, policy)
```

| Flag | Gera | Atalho |
|------|------|--------|
| `-m` | migration | `create_posts_table` |
| `-c` | `PostController` | `app/Http/Controllers` |
| `-f` | `PostFactory` | `database/factories` |
| `-s` | `PostSeeder` | `database/seeders` |
| `-a` | todos acima | `make:model Post -a` |

## 5.2 Anatomia do Model (atributo a atributo)

```php
class Post extends Model {
    protected $table = 'posts';           // 1. Tabela (padrão: plural snake_case do Model)
    protected $primaryKey = 'codigo';     // 2. PK se não for id (padrão id)
    public $incrementing = false;         // 3. Se PK não é AUTO_INCREMENT (ex: UUID)
    protected $keyType = 'string';        // 4. Se PK é string (UUID)
    public $timestamps = true;            // 5. created_at/updated_at (false desativa, ver cap. 03 timestamps())
    protected $fillable = ['titulo','conteudo']; // 6. Mass assignment lista branca (cap. 09)
    protected $guarded = ['id'];          // 6b. Alternativa: lista negra
    protected $hidden = ['senha'];        // 7. Oculta no JSON (não retorna senha)
    protected $casts = ['ativo' => 'boolean', 'publicado_em' => 'datetime']; // 8. Casting (cap. 07)
}
```

| Atributo | Padrão | Quando mudar | Se errar |
|----------|--------|--------------|----------|
| `$table` | `posts` (plural de `Post`) | Tabela legada `tbl_post` | `SQLSTATE[42S02]: Base table or view not found: tbl_post` |
| `$primaryKey` | `id` | PK `codigo` | `find()` busca `id` errado |
| `$incrementing` | `true` | PK UUID não numérica | `save()` falha |
| `$timestamps` | `true` | Tabela sem `created_at` | `Unknown column 'created_at'` |
| `$fillable` | `[]` (tudo bloqueado) | Sem ele, `create()` lança `MassAssignmentException` | cap. 09 |
| `$hidden` | `[]` | Senha exposta no `return $post` JSON | Vazamento |

**Convenção:** `Post` → `posts`, `Category` → `categories`, `PostTag` → `post_tag`. Siga, evita `protected $table`.

## 5.3 CRUD básico (com SQL equivalente)

```php
// CREATE (precisa $fillable)
$post = Post::create(['titulo' => 'Olá', 'conteudo' => '...', 'user_id' => 1]);
// SQL: INSERT INTO posts (titulo, ...) VALUES ('Olá', ...)

// READ
$post = Post::find(1); // PK 1 — null se não existe
$post = Post::findOrFail(1); // ou 404
$posts = Post::where('ativo', true)->where('user_id', 1)->orderBy('created_at')->get();
// SQL: SELECT * FROM posts WHERE ativo=1 AND user_id=1 ORDER BY created_at

// UPDATE (precisa $fillable ou forceFill)
$post->update(['titulo' => 'Novo']); // 1 query
Post::where('ativo', false)->update(['ativo' => true]); // mass update

// DELETE
$post->delete(); // soft ou hard (ver cap. 10)
Post::destroy([1,2,3]); // por PKs
```

**Erros comuns:**

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `MassAssignmentException: Add [titulo] to fillable` | `titulo` não está em `$fillable` | Adicione em `$fillable` (cap. 09) |
| `Base table or view not found` | `$table` errado ou migration não rodada | `php artisan migrate` + conferir `$table` |
| `Unknown column 'updated_at'` | `$timestamps = true` sem `timestamps()` na migration | `public $timestamps = false` ou adicione `timestamps()` |

---

⬅️ [Anterior: Seeders](./04-seeders-factories.md) | ➡️ [06. Relacionamentos](./06-relacionamentos.md) | [Sumário](./README.md)
