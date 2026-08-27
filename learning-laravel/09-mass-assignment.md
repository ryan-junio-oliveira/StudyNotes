# 09. Mass Assignment — Segurança

> Parte do [Curso Completo de Laravel](./README.md)

## 9.1 Por que `$fillable` existe?

```php
// ❌ sem fillable: usuário injeta is_admin=1
Post::create($request->all()); // se $request tiver is_admin, cria admin!

// ✅ com fillable: só campos listados entram
class Post extends Model {
    protected $fillable = ['titulo','conteudo','category_id'];
    // ou
    protected $guarded = ['id','is_admin']; // tudo menos estes
    // ou
    protected $guarded = ['*']; // bloqueia tudo (use forceFill)
}
```

|  | `fillable` | `guarded` |
|--|------------|-----------|
| Filosofia | Lista branca | Lista negra |
| Seguro | Mais | Menos (esquece um) |

**Erro:**

```
Illuminate\Database\Eloquent\MassAssignmentException: Add [titulo] to fillable
→ adicione ao $fillable
```

---

⬅️ [Anterior: Scopes/Observers](./08-scopes-observers.md) | ➡️ [10. Soft Deletes](./10-soft-deletes.md) | [Sumário](./README.md)
