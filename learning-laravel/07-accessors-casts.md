# 07. Accessors, Mutators e Casts (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 7.1 Accessor (get) vs Mutator (set) — analogia filtro

> **Accessor = filtro na saída** (ao ler `$post->titulo`, formata), **Mutator = filtro na entrada** (ao gravar `$post->titulo = 'ola'`, formata antes de salvar).

```php
// Laravel 9+: Attribute API (recomendado)
use Illuminate\Database\Eloquent\Casts\Attribute;

public function titulo(): Attribute {
    return Attribute::make(
        get: fn (string $value) => strtoupper($value), // accessor: leitura → MAIÚSCULO
        set: fn (string $value) => ucfirst($value),    // mutator: gravação → Ola
    );
}
// Uso:
$post = Post::find(1);
echo $post->titulo; // MAIÚSCULO (get)
$post->titulo = 'ola mundo'; // grava 'Ola mundo' (set) → $post->save()
```

| Fluxo | Método | Quando roda |
|-------|--------|-------------|
| Ler | `get` | `$post->titulo` |
| Gravar | `set` | `$post->titulo = 'x'` antes de `save()` |

**Antigo (ainda funciona, mas verboso):**

```php
public function getTituloAttribute($value) { return strtoupper($value); }
public function setTituloAttribute($value) { $this->attributes['titulo'] = ucfirst($value); }
```

> **Erro:** chamar `$post->getTituloAttribute()` direto — Eloquent chama via `__get('titulo')`.

## 7.2 `$casts` — conversão automática (tabela)

> Sem `casts`, `ativo` vem como `1`/`0` (string/int do MySQL). Com `casts`, vira `true`/`false`.

```php
protected $casts = [
    'ativo' => 'boolean',       // 1 → true, 0 → false (boolean PHP)
    'publicado_em' => 'datetime', // string → Carbon (data com ->format())
    'config' => 'array',        // JSON ↔ array (MySQL JSON)
    'preco' => 'decimal:2',     // "10.00" (string precisa para dinheiro)
    'avaliacao' => 'float',     // 4.5
];
// Uso:
$post->ativo === true // boolean, não 1
$post->publicado_em->format('d/m/Y') // Carbon
$post->config['tema'] // array, não JSON string
```

| Cast | Entrada MySQL | Saída PHP | Quando usar |
|------|---------------|-----------|-------------|
| `boolean` | `0`/`1` | `true`/`false` | `ativo` |
| `datetime` | `2024-01-01 10:00:00` | `Carbon` | `publicado_em` |
| `array` | `'{"a":1}'` | `['a'=>1]` | `config JSON` |
| `decimal:2` | `10` | `"10.00"` | Dinheiro |

**Diferença `casts` vs Accessor:**

- `casts` = conversão de **tipo** (`string` → `boolean`)
- `Attribute` = lógica **custom** (`strtoupper`)

## 7.3 Custom Cast (exemplo completo)

> Quando `casts` padrão não basta (ex: `R$ 10,00` ↔ `10.00`).

```php
// app/Casts/MoneyCast.php
class MoneyCast implements CastsAttributes {
    public function get($model, string $key, $value, array $attributes): string {
        return 'R$ ' . number_format($value, 2, ',', '.'); // leitura
    }
    public function set($model, string $key, $value, array $attributes): string {
        return str_replace(['R$', '.', ','], ['', '', '.'], $value); // "R$ 10,50" → "10.50"
    }
}
// Post.php
protected $casts = ['preco' => MoneyCast::class];
// $post->preco = 'R$ 10,50' → salva 10.50; echo $post->preco → "R$ 10,50"
```

---

⬅️ [Anterior: Relacionamentos](./06-relacionamentos.md) | ➡️ [08. Scopes e Observers](./08-scopes-observers.md) | [Sumário](./README.md)
