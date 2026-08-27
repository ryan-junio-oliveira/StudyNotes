# 21. Filas (Queues), Jobs e Eventos (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)
> **Fila = adia trabalho pesado (email, resize imagem) para não travar o request.**

## 21.1 Job + Queue (dissecado)

```bash
php artisan make:job SendPostPublishedEmail # cria app/Jobs/SendPostPublishedEmail.php
```

```php
class SendPostPublishedEmail implements ShouldQueue { // ShouldQueue = assíncrono
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    public function __construct(public Post $post) {} // serializa só id, não objeto inteiro
    public function handle(): void {
        Mail::to($this->post->author->email)->send(new PostPublishedMail($this->post));
    }
    public function failed(Throwable $e): void { Log::error("Job falhou: {$e->getMessage()}"); }
}
// Dispatch (em Controller/Observer)
SendPostPublishedEmail::dispatch($post)->onQueue('emails')->delay(now()->addMinutes(5));
SendPostPublishedEmail::dispatchSync($post); // síncrono (para teste)
```

**Worker:**

```bash
php artisan queue:work          # processa jobs (precisa estar rodando em produção via supervisor/horizon)
php artisan queue:listen        # re-inicia a cada job (dev)
php artisan queue:failed        # lista falhos
php artisan queue:retry all     # re-tenta
```

| Driver | Onde `jobs` ficam | Quando usar | Comando worker |
|--------|-------------------|-------------|----------------|
| `sync` | Memória (síncrono) | Dev (padrão `.env` `QUEUE_CONNECTION=sync`) | Nenhum |
| `database` | Tabela `jobs` (`php artisan queue:table && migrate`) | Simples sem Redis | `queue:work` |
| `redis` | Redis | Produção (rápido, `horizon`) | `horizon` |

**Erro:** `Queue driver [redis] not found` → `QUEUE_CONNECTION=database` no `.env` ou instale `predis`.

## 21.2 Eventos e Listeners (desacopla)

```bash
php artisan make:event PostPublished
php artisan make:listener SendEmailListener --event=PostPublished
# app/Providers/EventServiceProvider.php: PostPublished => [SendEmailListener::class]
```

```php
// Event
class PostPublished { public function __construct(public Post $post) {} }
// Listener
class SendEmailListener { public function handle(PostPublished $event): void { Mail::to(...)->send(...); } }
// Dispare
event(new PostPublished($post)); // ou Post::created → event em Observer
```

**Observer vs Evento:**

| Observer (cap. 08) | Evento/Listener |
|--------------------|-----------------|
| Acoplado ao Model (`PostObserver::created`) | Desacoplado (qualquer lugar dispara `event()`) |
| `Post` direto | `PostPublished` pode ter N listeners (email, slack, log) |

> **Falha de fila no Docker:** `rabbitmq` do `docker-compose.yml:78` é para `AMQP`; `QUEUE_CONNECTION=database` usa `mysql`, não precisa `rabbitmq`.

---

⬅️ [Anterior: API](./20-api-resources.md) | ➡️ [22. Testes e Deploy](./22-testes-deploy.md) | [Sumário](./README.md)
