# 21. Filas (Queues) e Eventos

> Parte do [Curso Completo de Laravel](./README.md)

## 21.1 Job + Queue (assíncrono)

```bash
php artisan make:job SendPostPublishedEmail
```

```php
class SendPostPublishedEmail implements ShouldQueue {
    use Dispatchable, Queueable;
    public function handle(): void { Mail::to($this->post->author)->send(new PostPublished($this->post)); }
}
// Dispatch
SendPostPublishedEmail::dispatch($post);
// Worker
php artisan queue:work
```

| Driver | Quando |
|--------|--------|
| `sync` | Dev (síncrono) |
| `database` | Simples (tabela `jobs`) |
| `redis` | Produção |

## 21.2 Eventos e Listeners

```bash
php artisan make:event PostPublished && php artisan make:listener SendEmail --event=PostPublished
// PostObserver::created → event(new PostPublished($post)) → Listener envia email
```

---

⬅️ [Anterior: API](./20-api-resources.md) | ➡️ [22. Testes e Deploy](./22-testes-deploy.md) | [Sumário](./README.md)
