# 10. Soft Deletes — Exclusão Lógica

> Parte do [Curso Completo de Laravel](./README.md)

## 10.1 Uso

```php
use Illuminate\Database\Eloquent\SoftDeletes;

class Post extends Model { use SoftDeletes; }

Schema::table('posts', fn ($t) => $t->softDeletes()); // deleted_at nullable
```

```php
$post->delete(); // não apaga, seta deleted_at = now()
Post::all(); // ignora deletados
Post::withTrashed()->get(); // inclui deletados
Post::onlyTrashed()->get(); // só deletados
$post->restore(); // desfaz
$post->forceDelete(); // apaga de verdade
```

**Quando usar?** Auditoria, "lixeira". Sem `SoftDeletes`, `delete()` é irreversível.

---

⬅️ [Anterior: Mass Assignment](./09-mass-assignment.md) | ➡️ [11. Collections e Resources](./11-collections-resources.md) | [Sumário](./README.md)
