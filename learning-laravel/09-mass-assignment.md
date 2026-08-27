# 09. Mass Assignment — Segurança (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 9.1 Por que `$fillable` existe? (analogia porteiro)

> **Mass assignment = `Post::create($request->all())` com tudo que veio do form.** Sem trava, usuário injeta `is_admin=1` e vira admin.

```php
// Attacker envia: titulo=Olá&is_admin=1
Post::create($request->all());
// Se is_admin for fillable, cria admin! ❌
```

**`$fillable` = lista branca (porteiro só deixa entrar quem está na lista).**

```php
class Post extends Model {
    protected $fillable = ['titulo','conteudo','category_id']; // ✅ só estes
    // Alternativas:
    // protected $guarded = ['id','is_admin']; // lista negra: tudo menos estes
    // protected $guarded = ['*']; // bloqueia tudo (use forceFill para admin)
}
```

|  | `$fillable` (branca) | `$guarded` (negra) | `$guarded = ['*']` |
|--|-------|-------|-----|
| Filosofia | Só entra o listado | Entra tudo exceto listado | Nada entra |
| Segurança | Mais (esqueceu campo → só não cria, não vaza) | Menos (esqueceu `is_admin` → vaza) | Máxima |
| Quando usar | Padrão | Tabela com muitos campos liberados | Model sensível (`User`) |

**Exemplos:**

```php
Post::create(['titulo' => 'Olá', 'conteudo' => '...', 'is_admin' => 1]);
// com fillable ['titulo','conteudo'] → is_admin é ignorado ✅

$post->fill(['titulo' => 'Novo', 'is_admin' => 1]); // fill também respeita fillable
$post->forceFill(['is_admin' => 1])->save(); // bypass fillable (admin interno)
```

**Erro clássico:**

```
Illuminate\Database\Eloquent\MassAssignmentException: Add [titulo] to fillable property to allow mass assignment on [App\Models\Post].
→ Solução: protected $fillable = ['titulo', ...]
```

> **Regra:** nunca `Post::create($request->all())` sem validar + `fillable`. Valide com `FormRequest` antes.

---

⬅️ [Anterior: Scopes/Observers](./08-scopes-observers.md) | ➡️ [10. Soft Deletes](./10-soft-deletes.md) | [Sumário](./README.md)
