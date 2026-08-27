# 01. Introdução — O que é Laravel (começando do zero)

> Parte do [Curso Completo de Laravel](./README.md) — Projeto **Blog** em `projeto-blog/`
> **Para quem nunca abriu um framework PHP.** Se já usa `php artisan`, pule para [02](./02-projeto-blog.md).

## 1.1 Por que Laravel? (analogia restaurante)

| Sem framework (PHP puro) | Com Laravel |
|--------------------------|-------------|
| `mysqli_connect` + SQL manual + `if ($_GET['page']=='posts')` | `Route::get('/posts', [PostController::class,'index'])` + `Post::all()` |
| Você cozinha, serve e lava louça na mesma bancada | **Cozinha separada:** Model (ingredientes), Controller (chef), View (prato) |

Laravel = **framework PHP** com **MVC** + **Eloquent ORM** (tradutor SQL→PHP) + **Artisan CLI** (assistente que gera código).

**Sem Laravel você repete; com Laravel você descreve.**

## 1.2 MVC em 30 segundos (com código real)

```
Browser --GET /posts--> Route --→ Controller --→ Model --→ Banco --→ View --→ HTML
                         |         |            Eloquent         Blade
                         Route::get('/posts', [PostController::class,'index']);
                         PostController::index() { Post::ativos()->with('category')->get(); return view(...); }
```

| Camada | Analogia restaurante | Arquivo | Exemplo |
|--------|---------------------|---------|---------|
| **Model** | Ingredientes + receita | `app/Models/Post.php` | `Post` ↔ `posts` (ver cap. 05) |
| **View** | Prato servido | `resources/views/posts/index.blade.php` | `{{ $post->titulo }}` |
| **Controller** | Chef que orquestra | `app/Http/Controllers/PostController.php` | `public function index() { ... }` |
| **Route** | Garçom que anota pedido | `routes/web.php` | `Route::get('/posts', ...)` |

> **Fluxo:** pedido → garçom (Route) → chef (Controller) pede ingredientes (Model/Eloquent) → monta prato (View/Blade).

## 1.3 Instalação e estrutura (dissecado)

```bash
composer create-project laravel/laravel blog   # 1. Baixa Laravel via Composer (gerenciador PHP)
cd blog                                        # 2. Entra na pasta
php artisan serve                              # 3. Sobe servidor http://127.0.0.1:8000

php artisan list                               # lista todos comandos
php artisan make:model Post -mcr               # -m migration, -c controller, -r resource (cap. 03/05)
```

| Comando | Gera | Atalho |
|---------|------|--------|
| `make:model Post -m` | `app/Models/Post.php` + `create_posts_table` | `Post -m` |
| `-c` | `PostController` | `make:controller` |
| `-r` | Controller resource (`index/create/store/show/edit/update/destroy`) | — |
| `make:factory PostFactory --model=Post` | `database/factories/PostFactory.php` | cap. 04 |

```
blog/
 ├─ app/Models/Post.php          ← Model/Eloquent (cap. 05) — "tradutor" da tabela
 ├─ database/migrations/         ← DDL versionado (cap. 03) — "planta da cozinha"
 ├─ database/factories/          ← dados fake (cap. 04) — "ingredientes de teste"
 ├─ database/seeders/            ← orquestra factories
 ├─ app/Http/Controllers/        ← Chef (cap. 13)
 ├─ routes/web.php               ← Garçom
 └─ .env                         ← Senha do banco (cap. 02 Docker) — nunca commitar!
```

**`.env` (analogia: chave do cofre):**

```env
DB_DATABASE=blog
DB_USERNAME=root
DB_PASSWORD=senha_forte  # ← vem do .env, não do código
```

> **Erro comum:** esquecer `composer install` → `Class 'Post' not found`; esquecer `.env` → `SQLSTATE[HY000] [1045] Access denied`.

## 1.4 Glossário mínimo (volte aqui)

| Termo | Analogia | Significado simples | Exemplo |
|-------|----------|---------------------|---------|
| **Artisan** | Assistente | CLI que gera código | `php artisan make:model` |
| **Migration** | Planta da cozinha | `CREATE TABLE` em PHP, versionado | `create_posts_table` |
| **Seeder/Factory** | Ingredientes fake | Popula banco para dev | `Post::factory()->count(10)->create()` |
| **Eloquent** | Tradutor | Classe ↔ tabela, sem SQL puro | `Post::where('ativo',1)->get()` |
| **Blade** | Cardápio | Template HTML com `{{ }}` | `{{ $post->titulo }}` |
| **Route** | Garçom | Liga URL → Controller | `Route::get('/posts', ...)` |

---

⬅️ [Sumário](./README.md) | ➡️ [02. Projeto Blog](./02-projeto-blog.md)
