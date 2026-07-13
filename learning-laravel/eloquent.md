
# 📘 TUTORIAL COMPLETO E EXPLICADO: ELOQUENT MODELS NO LARAVEL

---

## 📌 SUMÁRIO

1. [O que é o Eloquent ORM](#1)
2. [Criando Models](#2)
3. [Atributos Comuns e Configurações](#3)
4. [Relacionamentos e Tipos](#4)
5. [Accessors & Mutators (Getters e Setters)](#5)
6. [Casting de Atributos](#6)
7. [Query Scopes (Filtros reutilizáveis)](#7)
8. [Observers e Eventos](#8)
9. [Mass Assignment (Preenchimento em massa)](#9)
10. [Soft Deletes (Exclusão lógica)](#10)
11. [Custom Collections e Casts](#11)
12. [Outros Recursos Avançados](#12)

---

<a name="1"></a>
## ✅ 1. O que é o Eloquent ORM

Eloquent é o ORM (Object Relational Mapper) do Laravel. Ele permite que você trabalhe com o banco de dados usando classes PHP ao invés de SQL puro.

Cada **model representa uma tabela** e cada **instância representa uma linha**.

---

<a name="2"></a>
## 🛠️ 2. Criando Models

```bash
php artisan make:model Produto
```

Com migration, controller e resource:
```bash
php artisan make:model Produto -mcr
```

---

<a name="3"></a>
## 🧱 3. Atributos Comuns e Configurações

```php
class Produto extends Model
{
    protected $table = 'produtos';           // Define o nome da tabela
    protected $primaryKey = 'id';            // Chave primária
    public $timestamps = true;               // Cria 'created_at' e 'updated_at'
    protected $fillable = ['nome', 'preco']; // Permite preenchimento em massa
    protected $hidden = ['senha'];           // Oculta no JSON
    protected $casts = ['preco' => 'decimal:2']; // Converte tipo automaticamente
}
```

---

<a name="4"></a>
## 🔗 4. Relacionamentos e Tipos

Relacionamentos conectam tabelas:

- `hasOne` / `belongsTo`: 1:1
- `hasMany` / `belongsTo`: 1:N
- `belongsToMany`: N:N
- `morphTo`, `morphMany`: polimórficos

```php
public function categoria()
{
    return $this->belongsTo(Categoria::class);
}
```

```php
public function comentarios()
{
    return $this->hasMany(Comentario::class);
}
```

---

<a name="5"></a>
## 🧬 5. Accessors & Mutators (Getters e Setters)

### Accessor (personaliza valor na leitura):
```php
public function getNomeMaiusculoAttribute()
{
    return strtoupper($this->nome);
}
```

### Mutator (personaliza valor na escrita):
```php
public function setNomeAttribute($value)
{
    $this->attributes['nome'] = ucfirst($value);
}
```

---

<a name="6"></a>
## 🔁 6. Casting de Atributos

Converte tipos automaticamente:

```php
protected $casts = [
    'ativo' => 'boolean',
    'config' => 'array',
    'criado_em' => 'datetime',
];
```

---

<a name="7"></a>
## 🔍 7. Query Scopes (Filtros reutilizáveis)

Permite criar filtros reutilizáveis nos models.

```php
public function scopeAtivos($query)
{
    return $query->where('ativo', true);
}
```

Uso:
```php
Produto::ativos()->get();
```

---

<a name="8"></a>
## 🧠 8. Observers e Eventos

Permite executar lógica quando algo acontece com o model (ex: salvando, criando, excluindo...).

```bash
php artisan make:observer ProdutoObserver --model=Produto
```

```php
public function creating(Produto $produto)
{
    $produto->slug = Str::slug($produto->nome);
}
```

---

<a name="9"></a>
## 🛡️ 9. Mass Assignment (Preenchimento em massa)

### Para segurança, o Laravel exige que você declare quais campos podem ser preenchidos:

```php
protected $fillable = ['nome', 'preco'];
```

ou bloquear todos:

```php
protected $guarded = ['*'];
```

---

<a name="10"></a>
## 🧼 10. Soft Deletes (Exclusão lógica)

### Para que serve?

Permite **"excluir" registros sem realmente apagar do banco**. Em vez disso, ele preenche a coluna `deleted_at`.

### Como usar:

```php
use Illuminate\Database\Eloquent\SoftDeletes;

class Produto extends Model
{
    use SoftDeletes;
}
```

Na migration:

```php
$table->softDeletes();
```

### Consultas:

```php
Produto::withTrashed()->get();      // Todos
Produto::onlyTrashed()->restore();  // Restaurar
Produto::find($id)->forceDelete();  // Excluir permanentemente
```

---

<a name="11"></a>
## 🔄 11. Custom Collections e Casts

### Custom Collection:
```php
class ProdutoCollection extends Illuminate\Database\Eloquent\Collection
{
    public function ativos()
    {
        return $this->filter->ativo;
    }
}
```

### Custom Cast:
```php
class CurrencyCast implements CastsAttributes
{
    public function get($model, string $key, $value, array $attributes)
    {
        return 'R$ ' . number_format($value, 2, ',', '.');
    }

    public function set($model, string $key, $value, array $attributes)
    {
        return str_replace(['R$', ',', '.'], ['', '.', ''], $value);
    }
}
```

---

<a name="12"></a>
## 🧰 12. Outros Recursos Avançados

- `withDefault()`: Define valor padrão para relacionamentos `belongsTo`
- `replicate()`: Clona uma instância do model
- `touches`: Atualiza timestamps de pai quando filho muda
- `appends`: Força atributos calculados no JSON
- `loadMissing()`: Lazy eager load
- `firstOrCreate()`: Cria registro se não existir
- `updateOrCreate()`: Atualiza ou cria

```php
User::firstOrCreate(['email' => $email], ['name' => $nome]);
```

---

Este material explica cada conceito com exemplos e objetivos. Ideal para revisão, estudo ou aplicação prática.
