# Curso Completo de Laravel — Do Zero ao Framework Avançado

> **Projeto fio-condutor: Blog** (`users` → `posts` → `tags`/`comments`). De `migrate` até `deploy` + filas e testes.

---

## 📚 Sumário

| # | Capítulo | Conteúdo | Arquivo |
|---|----------|----------|---------|
| 01 | **Introdução** | MVC, Artisan, instalação, estrutura, glossário | [01-introducao.md](./01-introducao.md) |
| 02 | **Projeto Blog** | ER `users/posts/tags/comments`, 1:N/N:N, fio-condutor | [02-projeto-blog.md](./02-projeto-blog.md) |
| 03 | **Migrations** | `make:migration`, `Schema::create` dissecado, tipos, FK, `Schema::table`, artisan | [03-migrations.md](./03-migrations.md) |
| 04 | **Seeders e Factories** | `make:factory/seeder`, `Faker`, `migrate:fresh --seed` | [04-seeders-factories.md](./04-seeders-factories.md) |
| 05 | **Eloquent Básico** | `make:model -mcr`, `$table`/`$fillable`/`$casts`/`$timestamps`, CRUD | [05-eloquent-basico.md](./05-eloquent-basico.md) |
| 06 | **Relacionamentos** | `hasMany`/`belongsTo`/`belongsToMany`/`morph`, `with()` N+1, `attach`/`sync` | [06-relacionamentos.md](./06-relacionamentos.md) |
| 07 | **Accessors, Mutators e Casts** | `Attribute` API, `$casts`, custom `CastsAttributes` | [07-accessors-casts.md](./07-accessors-casts.md) |
| 08 | **Scopes e Observers** | `scopeAtivos`, `PostObserver` + `creating`/`saving` | [08-scopes-observers.md](./08-scopes-observers.md) |
| 09 | **Mass Assignment** | `$fillable` vs `$guarded`, `MassAssignmentException` | [09-mass-assignment.md](./09-mass-assignment.md) |
| 10 | **Soft Deletes** | `SoftDeletes`, `withTrashed`/`restore`/`forceDelete` | [10-soft-deletes.md](./10-soft-deletes.md) |
| 11 | **Collections e Avançados** | Custom `Collection`, `withDefault`, `replicate`, `touches`, `firstOrCreate` | [11-collections-resources.md](./11-collections-resources.md) |
| 12 | **Boas Práticas** | `constrained()`+`with()`, triggers raw, `schema:dump` | [12-boas-praticas.md](./12-boas-praticas.md) |
| 13 | **Projeto Blog (lab)** | `laravel new blog` passo a passo amarrando caps. 03-10 | [13-projeto-blog-lab.md](./13-projeto-blog-lab.md) |
| 14 | **Rotas e Controllers** | `Route::resource`, 7 métodos, implicit binding | [14-rotas-controllers.md](./14-rotas-controllers.md) |
| 15 | **Blade** | `@extends`/`@section`/`@foreach`, componentes `x-alert` | [15-blade-views.md](./15-blade-views.md) |
| 16 | **Validação** | `validate()` + `FormRequest`, regras `unique`/`exists` | [16-validacao.md](./16-validacao.md) |
| 17 | **Autenticação** | Breeze, `auth`/`guest` middleware, `Auth::check()` | [17-autenticacao.md](./17-autenticacao.md) |
| 18 | **Autorização** | `Gate` vs `Policy`, `@can`, `403` | [18-autorizacao.md](./18-autorizacao.md) |
| 19 | **Middleware e Providers** | `make:middleware`, `Kernel.php`, `ServiceProvider` | [19-middleware-providers.md](./19-middleware-providers.md) |
| 20 | **API Resources e Paginação** | `JsonResource`, `paginate` vs `cursorPaginate` | [20-api-resources.md](./20-api-resources.md) |
| 21 | **Filas e Eventos** | `ShouldQueue`, `queue:work`, `Event`/`Listener` | [21-queues-events.md](./21-queues-events.md) |
| 22 | **Testes e Deploy** | Pest/PHPUnit, `config:cache`, `optimize` | [22-testes-deploy.md](./22-testes-deploy.md) |

### 📦 Projeto

| Arquivo | Descrição |
|---------|-----------|
| [`projeto-blog/app/Models/Post.php`](./projeto-blog/app/Models/Post.php) | Model referência com `SoftDeletes`, relações, `scope`, `Attribute` |
| [`projeto-blog/database/migrations/..._create_posts_table.php.example`](./projeto-blog/database/migrations/2024_01_01_000001_create_posts_table.php.example) | Migration referência |

---

## 🗺️ Trilha

```
01 Intro (MVC) → 02 Blog (ER)
   ↓
03 Migrations → 04 Seeders/Factories → 05 Models
   ↓
06 Relacionamentos → 07 Accessors/Casts → 08 Scopes/Observers
   ↓
09 Mass Assignment → 10 Soft Deletes → 11 Collections → 12 Boas Práticas → 13 Lab
   ↓
14 Rotas/Controllers → 15 Blade → 16 Validação → 17 Auth → 18 Gates/Policies
   ↓
19 Middleware/Providers → 20 API Resources → 21 Queues/Events → 22 Testes/Deploy
```

Comece por [01. Introdução](./01-introducao.md) →
