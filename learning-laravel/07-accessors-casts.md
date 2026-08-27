# 07. Accessors, Mutators e Casts

> Parte do [Curso Completo de Laravel](./README.md)

## 7.1 Accessor (get) vs Mutator (set)

```php
// Laravel 9+: Attribute API
use Illuminate\Database\Eloquent\Casts\Attribute;

public function titulo(): Attribute {
    return Attribute::make(
        get: fn (string $value) => strtoupper($value), // ao ler
        set: fn (string $value) => ucfirst($value),    // ao gravar
    );
}
// Uso: $post->titulo (lê maiúsculo), $post->titulo = 'ola' (grava 'Ola')
```

Antigo (ainda funciona): `getTituloAttribute()` / `setTituloAttribute($value)`.

## 7.2 `$casts` — conversão automática

```php
protected $casts = [
    'ativo' => 'boolean',
    'publicado_em' => 'datetime',
    'config' => 'array',       // JSON ↔ array
    'preco' => 'decimal:2',
];
// $post->ativo === true (boolean, não 1)
```

## 7.3 Custom Cast

```php
class MoneyCast implements CastsAttributes {
    public function get($model, $key, $value, $attributes) { return 'R$ '.number_format($value,2,',','.'); }
    public function set($model, $key, $value, $attributes) { return str_replace(['R$','.',','], ['','','.'], $value); }
}
protected $casts = ['preco' => MoneyCast::class];
```

---

⬅️ [Anterior: Relacionamentos](./06-relacionamentos.md) | ➡️ [08. Scopes e Observers](./08-scopes-observers.md) | [Sumário](./README.md)
