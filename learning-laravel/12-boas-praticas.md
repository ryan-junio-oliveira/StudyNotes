# 12. Boas Práticas e Recursos Extras

> Parte do [Curso Completo de Laravel](./README.md)

## 12.1 Checklist (tabela)

| Prática | Por quê | Como |
|---------|---------|------|
| `foreignId()->constrained()->onDelete('cascade')` | FK correta, sem `Cannot add foreign key` | cap. 03 |
| `with('author','tags')` | Evita N+1 (cap. 06) | `Post::with(...)->get()` |
| `fillable` + `casts` | Segurança + tipo correto | caps. 09 e 07 |
| `scopes` + `Observers` | Controller magro | cap. 08 |
| `SoftDeletes` + `withTrashed` | Lixeira | cap. 10 |
| `migrate:fresh --seed` no dev | Dados fake coerentes | cap. 04 |
| Comente `DB::unprepared` | Trigger raw é opaco | `// slug trigger` |

## 12.2 Triggers via SQL Raw (quando Eloquent não basta)

```php
use Illuminate\Support\Facades\DB;

public function up(): void {
    DB::unprepared('
        CREATE TRIGGER set_slug BEFORE INSERT ON posts FOR EACH ROW
        SET NEW.slug = LOWER(REPLACE(NEW.title, " ", "-"))
    ');
}
public function down(): void { DB::unprepared('DROP TRIGGER IF EXISTS set_slug'); }
```

> Prefira `Observer` (PHP) a `Trigger` (SQL) — mais testável, portável.

## 12.3 Outros comandos

```bash
php artisan schema:dump   # gera database/schema/mysql-schema.sql para migrate rápido em CI
php artisan model:show Post # mostra fillable, casts, relações
```

---

⬅️ [Anterior: Collections](./11-collections-resources.md) | ➡️ [13. Projeto Blog (lab)](./13-projeto-blog-lab.md) | [Sumário](./README.md)
