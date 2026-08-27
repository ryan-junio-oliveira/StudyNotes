# 04. Seeders e Factories — Populando o Blog (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 4.1 Por que não `INSERT` manual? (analogia)

| Manual | Factory/Seeder |
|--------|----------------|
| `INSERT INTO posts VALUES ('abc','abc')` repetitivo | `Post::factory()->count(50)->create()` gera 50 posts coerentes |
| Dados fake para dev/teste na mão | `Faker` gera `sentence`, `slug`, `boolean` |

> **Seeder = orquestrador, Factory = fábrica** — Seeder chama Factory na ordem FK correta.

## 4.2 Criando (sintaxe dissecada)

```bash
php artisan make:factory PostFactory --model=Post  # 1. Liga factory ao Model Post
php artisan make:seeder PostSeeder                # 2. Orquestrador
php artisan db:seed                               # 3. Roda DatabaseSeeder (chama todos)
php artisan migrate:fresh --seed                  # 4. Apaga + cria + popula (dev)
```

**Onde ficam:**

```
database/factories/PostFactory.php   ← define como gerar 1 Post
database/seeders/PostSeeder.php      ← define quantos e em que ordem
database/seeders/DatabaseSeeder.php  ← orquestra: $this->call([CategorySeeder::class, PostSeeder::class])
```

## 4.3 Factory (Faker) dissecada

```php
// database/factories/PostFactory.php
public function definition(): array {
    return [
        'titulo' => fake()->sentence(3),          // 1. "Lorem ipsum dolor." (3 palavras)
        'slug' => fake()->unique()->slug(),       // 2. "lorem-ipsum-dolor" único (evita Duplicate slug)
        'conteudo' => fake()->paragraphs(3, true),// 3. 3 parágrafos, true = string, false = array
        'user_id' => User::factory(),             // 4. Cria User e usa id (FK automática)
        'category_id' => Category::factory(),     // 5. Idem para Category
        'ativo' => fake()->boolean(80),           // 6. 80% true, 20% false
        'publicado_em' => fake()->optional()->dateTime(), // 7. 50% null, 50% data
    ];
}
```

| `fake()` | O que gera | Uso |
|----------|------------|-----|
| `sentence(3)` | Frase 3 palavras | `titulo` |
| `slug()` | `lorem-ipsum` | `slug` com `unique()` |
| `paragraphs(3,true)` | Texto longo | `conteudo` |
| `boolean(80)` | `true` 80% | `ativo` |
| `randomElement(['a','b'])` | Um dos valores | `status` |
| `User::factory()` | FK automática | `user_id` cria pai |

**Uso:**

```php
Post::factory()->count(50)->create();              // 50 posts
Post::factory()->unpublished()->create();          // com state (ver abaixo)
```

**States (variações):**

```php
public function unpublished(): static { return $this->state(fn() => ['ativo' => false]); }
Post::factory()->unpublished()->count(5)->create();
```

## 4.4 Seeder (ordem FK importa!)

```php
// database/seeders/DatabaseSeeder.php
public function run(): void {
    $this->call([
        CategorySeeder::class, // 1. Pai primeiro (posts depende de categories)
        UserSeeder::class,     // 2. Users antes de posts
        PostSeeder::class,     // 3. Posts por último (usa user_id, category_id)
    ]);
}

// database/seeders/PostSeeder.php
public function run(): void {
    Category::factory()->count(3)->create();
    User::factory()->count(5)->create();
    Post::factory()->count(20)->create();
}
```

**Erro comum:**

```
SQLSTATE[23000]: Integrity constraint violation: 1452 Cannot add foreign key — category_id
→ CategorySeeder não rodou antes de PostSeeder — ordem no DatabaseSeeder
```

## 4.5 Comandos (tabela)

| Comando | O que faz | Quando |
|---------|-----------|--------|
| `migrate:fresh --seed` | Apaga tudo + seed | Dev (perde dados!) |
| `db:seed --class=PostSeeder` | Só este seeder | Teste |
| `tinker` → `Post::factory()->create()` | Cria 1 no REPL | Debug |

---

⬅️ [Anterior: Migrations](./03-migrations.md) | ➡️ [05. Eloquent Básico](./05-eloquent-basico.md) | [Sumário](./README.md)
