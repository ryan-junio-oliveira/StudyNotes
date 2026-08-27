# 04. Seeders e Factories — Populando o Blog

> Parte do [Curso Completo de Laravel](./README.md)

## 4.1 Por que não `INSERT` manual?

Factories geram dados fake coerentes para dev/teste; seeders orquestram.

```bash
php artisan make:factory PostFactory --model=Post
php artisan make:seeder PostSeeder
php artisan db:seed              # roda DatabaseSeeder
php artisan migrate:fresh --seed # recria + popula
```

## 4.2 Factory (Faker)

```php
// database/factories/PostFactory.php
public function definition(): array {
    return [
        'titulo' => fake()->sentence(3),
        'slug' => fake()->unique()->slug(),
        'conteudo' => fake()->paragraphs(3, true),
        'user_id' => User::factory(),
        'category_id' => Category::factory(),
        'ativo' => fake()->boolean(80),
    ];
}
// Uso: Post::factory()->count(50)->create();
```

## 4.3 Seeder

```php
// database/seeders/PostSeeder.php
public function run(): void {
    Category::factory()->count(3)->create();
    Post::factory()->count(20)->create();
}
```

**Ordem:** `CategorySeeder` antes de `PostSeeder` (FK).

---

⬅️ [Anterior: Migrations](./03-migrations.md) | ➡️ [05. Eloquent Básico](./05-eloquent-basico.md) | [Sumário](./README.md)
