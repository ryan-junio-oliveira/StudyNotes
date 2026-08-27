# 12. Boas Práticas e Outros Recursos

> Parte do [Curso Completo de Laravel](./README.md)

- Use `foreignId()->constrained()` (cap. 03) e `with()` para N+1.
- Nunca edite migration já migrada em produção — nova migration.
- Use factories + seeders + `migrate:fresh --seed` no dev.
- Valide `fillable` (cap. 09) e `casts` (cap. 07).
- Comente `DB::unprepared` (triggers).
- `php artisan schema:dump` para `migrate` rápido em CI.

```php
// Triggers via raw (ver migrations.md original)
DB::unprepared('CREATE TRIGGER set_slug BEFORE INSERT ON posts FOR EACH ROW SET NEW.slug = LOWER(REPLACE(NEW.title," ","-"))');
```

---

⬅️ [Anterior: Collections](./11-collections-resources.md) | ➡️ [13. Projeto Blog (lab)](./13-projeto-blog-lab.md) | [Sumário](./README.md)
