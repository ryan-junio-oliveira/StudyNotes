# 13. Projeto Blog — Lab Mão na Massa

> Parte do [Curso Completo de Laravel](./README.md)

```bash
laravel new blog && cd blog
php artisan make:model Post -mcr
# edite migration (cap. 03) com posts + foreignId
php artisan migrate
php artisan make:factory PostFactory --model=Post
php artisan make:seeder PostSeeder
php artisan migrate:fresh --seed
php artisan tinker
>>> Post::with('author','tags')->ativos()->get();
>>> Post::factory()->count(5)->create();
```

**Checklist do lab:**

- [ ] Migrations `posts`, `categories`, `tags`, `post_tag` (cap. 03)
- [ ] Factories + Seeders (cap. 04)
- [ ] Models com `$fillable`, `$casts`, `SoftDeletes` (caps. 05,07,10)
- [ ] Relacionamentos `hasMany`/`belongsToMany` + `with()` (cap. 06)
- [ ] Scopes `ativos()` + Observer `slug` (cap. 08)

Valide com `php artisan tinker` e `projeto-blog/` como referência.

---

⬅️ [Anterior: Boas Práticas](./12-boas-praticas.md) | [Sumário](./README.md)
