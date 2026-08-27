# 13. Projeto Blog — Lab Mão na Massa (checklist completo)

> Parte do [Curso Completo de Laravel](./README.md)
> **Faça junto:** `projeto-blog/` tem `Post.php` e migration de referência.

## 13.1 Passo a passo (ordem FK importa!)

```bash
laravel new blog && cd blog
php artisan make:model Post -mcr          # Model + migration + controller resource
# 1. Edite migration posts (cap. 03): id, titulo, slug unique, conteudo, user_id FK → users, category_id FK → categories
php artisan migrate                        # cria users, categories, posts, post_tag
php artisan make:factory PostFactory --model=Post
php artisan make:seeder PostSeeder         # Category::factory()->count(3) antes de Post::factory
php artisan migrate:fresh --seed           # apaga + cria + popula
php artisan tinker
>>> Post::with('author','tags')->ativos()->get();
>>> Post::factory()->count(5)->create();
>>> Post::withTrashed()->get();
```

## 13.2 Checklist do lab (marque ao fazer)

- [ ] **03 Migrations** `users`, `categories`, `posts`, `tags`, `post_tag` (PK composta), `comments` com `foreignId()->constrained()`
- [ ] **04 Factories/Seeders** `PostFactory` com `Faker` + `DatabaseSeeder` na ordem correta
- [ ] **05 Models** `protected $fillable`, `$casts`, `$hidden`, `SoftDeletes`
- [ ] **06 Relacionamentos** `hasMany`/`belongsTo`/`belongsToMany` + `with()` para N+1 + `attach`/`sync`
- [ ] **07 Accessors/Casts** `Attribute` + `MoneyCast` + `$casts boolean/datetime`
- [ ] **08 Scopes/Observers** `scopeAtivos()` + `PostObserver::creating` para `slug`
- [ ] **09-10** `fillable` + `SoftDeletes` `withTrashed/restore`
- [ ] **Tinker** `Post::ativos()->with('category')->first()->resumo` (appends)

**Validação:** `php artisan model:show Post` deve listar `author`, `tags`, `category`, `comments`.

---

⬅️ [Anterior: Boas Práticas](./12-boas-praticas.md) | [Sumário](./README.md)
