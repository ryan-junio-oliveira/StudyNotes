# 17. Autenticação — Breeze/Jetstream (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 17.1 Breeze (starter kit leve)

```bash
composer require laravel/breeze --dev
php artisan breeze:install blade
npm install && npm run dev
php artisan migrate
```

Gera `login`, `register`, `forgot-password`, `ProfileController` + views.

## 17.2 Como funciona

```php
Route::middleware('auth')->group(function () {
    Route::get('/dashboard', fn() => view('dashboard'));
});
Route::middleware('guest')->group(function () {
    Route::get('/login', [AuthenticatedSessionController::class, 'create']);
});

auth()->user(); // User logado
auth()->id();   // id
Auth::check();  // logado?
```

| Guard | Session (web) | Token (api) |
|-------|---------------|-------------|
| `web` | `auth` padrão (cookie) | — |
| `api` | — | `Sanctum`/`Passport` |

> **Erro:** `Route [login] not defined` → instale Breeze ou defina `Route::get('/login')->name('login')`.

---

⬅️ [Anterior: Validação](./16-validacao.md) | ➡️ [18. Autorização](./18-autorizacao.md) | [Sumário](./README.md)
