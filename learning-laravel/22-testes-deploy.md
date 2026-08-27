# 22. Testes e Deploy (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 22.1 Testes (Pest/PHPUnit) dissecado

```bash
php artisan make:test PostTest --unit # unit: sem Laravel (rápido)
php artisan make:test PostTest        # feature: com Laravel (HTTP, banco)
```

```php
// tests/Feature/PostTest.php (Pest)
use Illuminate\Foundation\Testing\RefreshDatabase;
uses(RefreshDatabase::class); // migrate:fresh a cada teste

test('post pode ser criado', function () {
    $user = User::factory()->create();
    $post = Post::factory()->for($user)->create(['titulo' => 'Teste']);
    expect($post->titulo)->toBe('Teste');
    $this->assertDatabaseHas('posts', ['titulo' => 'Teste']);
});
test('guest não cria post', function () {
    $this->post('/posts', ['titulo' => 'X'])->assertRedirect('/login'); // auth (cap. 17)
});
test('política bloqueia', function () {
    $other = User::factory()->create();
    $post = Post::factory()->create(['user_id' => $other->id]);
    actingAs(User::factory()->create())->put("/posts/{$post->id}", [...])->assertForbidden(); // 403 (cap. 18)
});
```

```bash
php artisan test                # roda Pest/PHPUnit
php artisan test --filter="post pode ser criado"
```

## 22.2 Deploy checklist (tabela)

```bash
composer install --no-dev --optimize-autoloader # 1. Só prod
php artisan config:cache   # 2. Cache .env → bootstrap/cache/config.php (se mudar .env, recache!)
php artisan route:cache    # 3. Cache rotas (se usar Closure em rota, falha)
php artisan view:cache     # 4. Cache Blade
php artisan migrate --force # 5. --force sem confirmar em prod
php artisan storage:link   # 6. public/storage → storage/app/public
php artisan queue:restart  # 7. Reinicia workers
```

| Comando | O que faz | Se errar |
|---------|-----------|----------|
| `config:cache` | Lê `.env` uma vez | Mudou `.env` sem `config:cache` → continua valor antigo |
| `route:cache` | Cache `routes/*.php` | `LogicException: Unable to prepare route [...] for serialization. Uses Closure` → troque Closure por Controller |
| `optimize` | Alias para `config:cache`+`route:cache`+`view:cache` | `optimize:clear` limpa tudo |
| `horizon` | Dashboard de filas (Redis) | Sem `horizon`, `queue:work` manual |

**Rollback:** `php artisan migrate:rollback` ou `down` em deploy blue-green.

> **Pipeline:** `composer install → npm run build → migrate --force → cache → queue:restart`.

---

⬅️ [Anterior: Filas](./21-queues-events.md) | [Sumário](./README.md)
