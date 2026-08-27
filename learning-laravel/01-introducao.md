# 01. Introdução — O que é Laravel (começando do zero)

> Parte do [Curso Completo de Laravel](./README.md) — Projeto **Blog** em `projeto-blog/`
> **Para quem nunca abriu um framework PHP.** Se já usa `php artisan`, pule para [02](./02-projeto-blog.md).

## 1.1 Por que Laravel?

| Sem framework | Com Laravel |
|---------------|-------------|
| `mysqli_connect` + SQL manual + `if` de rota na mão | `Route::get` + Eloquent `Post::all()` + Blade `{{ $post->titulo }}` |
| Repetição, SQL injection fácil | MVC organizado, ORM seguro, artisan gera tudo |

Laravel = **framework PHP** com **MVC** (Model-View-Controller) + **Eloquent ORM** + **Artisan CLI**.

## 1.2 MVC em 20 segundos

```
Browser → Route (rota) → Controller (lógica) → Model (Eloquent → banco) → View (Blade) → HTML
          |                                        ↑
          └─────── exemplo: GET /posts ────────────┘
Route::get('/posts', [PostController::class, 'index']); // rota
Post::with('categoria')->ativos()->get();               // Model (cap. 05-08)
return view('posts.index', ['posts' => $posts]);        // View
```

- **Model:** classe que representa tabela (`Post` ↔ `posts`)
- **View:** HTML com `Blade` (`{{ }}`)
- **Controller:** orquestra (`PostController@index`)

## 1.3 Instalação e estrutura

```bash
composer create-project laravel/laravel blog
cd blog
php artisan serve  # http://127.0.0.1:8000

php artisan list                  # todos comandos
php artisan make:model Post -mcr  # Model + Migration + Controller + Resource
```

```
blog/
 ├─ app/Models/Post.php       ← Eloquent (cap. 05)
 ├─ database/migrations/      ← DDL versionado (cap. 03)
 ├─ database/factories/       ← dados fake (cap. 04)
 ├─ app/Http/Controllers/     ← Controller
 └─ routes/web.php            ← Rotas
```

**Glossário mínimo:**

| Termo | Significado | Exemplo |
|-------|-------------|---------|
| **Artisan** | CLI do Laravel | `php artisan make:model` |
| **Migration** | DDL versionado ( `CREATE TABLE` em PHP) | `create_posts_table` |
| **Seeder/Factory** | Popula banco fake | `Post::factory()->count(10)->create()` |
| **Eloquent** | ORM: classe ↔ tabela | `Post::where('ativo',1)->get()` |
| **Blade** | Template HTML | `{{ $post->titulo }}` |

> **.env** guarda senha do banco — nunca commitar (ver `.gitignore` cap. 02 Docker).

---

⬅️ [Sumário](./README.md) | ➡️ [02. Projeto Blog](./02-projeto-blog.md)
