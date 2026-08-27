# 10. Soft Deletes — Exclusão Lógica (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)
> **Soft delete = "arquivar" em vez de apagar.** `deleted_at` guarda quando arquivou; `delete()` não apaga do banco.

## 10.1 Ativando

```php
// 1. Model
use Illuminate\Database\Eloquent\SoftDeletes;
class Post extends Model { use SoftDeletes; } // trait

// 2. Migration
Schema::table('posts', fn (Blueprint $table) => $table->softDeletes());
// Cria deleted_at TIMESTAMP NULL — null = ativo, com data = arquivado

// 3. Opcional: índice
$table->softDeletes()->index();
```

| Sem `SoftDeletes` | Com `SoftDeletes` |
|-------------------|-------------------|
| `DELETE FROM posts WHERE id=1` — some para sempre | `UPDATE posts SET deleted_at=NOW() WHERE id=1` — fica no banco |

## 10.2 Consultas (tabela)

```php
$post->delete(); // arquiva: deleted_at = now()
Post::all(); // ignora arquivados (WHERE deleted_at IS NULL automático)
Post::withTrashed()->get(); // inclui arquivados
Post::onlyTrashed()->get(); // só arquivados (lixeira)
$post->restore(); // desfaz: deleted_at = null
$post->forceDelete(); // apaga de verdade (DELETE)
Post::onlyTrashed()->restore(); // restaura todos da lixeira
```

**Visual:**

```
posts (com softDeletes)
┌────┬────────┬─────────────────────┐
│ id │ titulo │ deleted_at          │
├────┼────────┼─────────────────────┤
│ 1  │ Post A │ null (ativo)        │
│ 2  │ Post B │ 2024-08-27 10:00:00 │ ← arquivado, não aparece em Post::all()
└────┴────────┴─────────────────────┘
```

**Quando usar?** Auditoria, "lixeira" do usuário, recuperação. Sem soft delete, `delete()` é irreversível (só com backup).

> **Cuidado:** `withTrashed()` em relacionamentos: `$user->posts()->withTrashed()->get()` — senão posts arquivados somem do `hasMany`.

---

⬅️ [Anterior: Mass Assignment](./09-mass-assignment.md) | ➡️ [11. Collections e Resources](./11-collections-resources.md) | [Sumário](./README.md)
