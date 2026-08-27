# 22. Testes e Deploy

> Parte do [Curso Completo de Laravel](./README.md)

## 22.1 Testes (Pest/PHPUnit)

```bash
php artisan make:test PostTest
```

```php
test('post pode ser criado', function () {
    $post = Post::factory()->create();
    expect($post->titulo)->not->toBeEmpty();
});
php artisan test
```

## 22.2 Deploy checklist

```bash
composer install --no-dev --optimize-autoloader
php artisan config:cache && php artisan route:cache && php artisan view:cache
php artisan migrate --force
php artisan storage:link
```

| Comando | O que faz |
|---------|-----------|
| `config:cache` | Cache `.env` |
| `optimize` | Limpa e re-cache tudo |
| `horizon` | Monitor de queues (Redis) |

---

⬅️ [Anterior: Filas](./21-queues-events.md) | [Sumário](./README.md)
