# 17. Autenticação — Deep Dive (muito explicativo)

> Parte do [Curso Completo de Laravel](./README.md)
> **Objetivo:** entender **o que Breeze faz por você** e **como funciona por baixo** (não só copiar 3 comandos).

## 17.1 Autenticação vs Autorização (glossário)

| Conceito | Pergunta | Exemplo Blog | Arquivo |
|----------|----------|--------------|---------|
| **Autenticação (authN)** | Quem é você? | Login com email/senha | `17` este capítulo |
| **Autorização (authZ)** | Pode fazer? | Só autor edita post (cap. 18) | `Gate`/`Policy` |
| **Guard** | Como autenticar? | `web` (session/cookie) vs `api` (token) | `config/auth.php` |
| **Provider** | De onde vem usuário? | `users` → `App\Models\User` via Eloquent | `config/auth.php` |

## 17.2 Guards e Providers (dissecado)

```php
// config/auth.php
'defaults' => ['guard' => 'web', 'passwords' => 'users'],
'guards' => [
    'web' => ['driver' => 'session', 'provider' => 'users'], // cookie → session
    'api' => ['driver' => 'sanctum', 'provider' => 'users'], // token → Sanctum (cap. 20)
],
'providers' => [
    'users' => ['driver' => 'eloquent', 'model' => App\Models\User::class],
],
```

| Guard | Driver | Onde guarda "logado" | Quando usar |
|-------|--------|----------------------|-------------|
| `web` | `session` | Cookie `laravel_session` + DB `sessions` | Blade (navegador) |
| `api` | `sanctum`/`token` | `Authorization: Bearer <token>` | API/mobile |

```php
auth()->guard('web')->user(); // User logado no web
auth('api')->user(); // User via token
```

## 17.3 Breeze — o que os 3 comandos fazem (dissecado)

```bash
composer require laravel/breeze --dev   # 1. Baixa starter kit (views + controllers Auth)
php artisan breeze:install blade        # 2. Publica: routes/auth.php + Controllers/Auth/* + views/auth/* + tailwind
npm install && npm run dev              # 3. Compila CSS/JS (Vite)
php artisan migrate                      # 4. Cria sessions/password_reset_tokens
```

**O que `breeze:install` criou:**

```
routes/auth.php              ← login, register, forgot-password, verify-email
app/Http/Controllers/Auth/   ← AuthenticatedSessionController, RegisteredUserController...
resources/views/auth/        ← login.blade.php, register.blade.php
```

**Sem Breeze (manual mínimo):**

```php
Route::get('/login', [AuthenticatedSessionController::class,'create'])->middleware('guest')->name('login');
Route::post('/login', [AuthenticatedSessionController::class,'store']);
Route::post('/logout', [AuthenticatedSessionController::class,'destroy'])->middleware('auth');
```

## 17.4 Como funciona por baixo (registro → login → hash → remember)

**Registro:**

```php
// RegisteredUserController::store()
$user = User::create([
    'name' => $request->name,
    'email' => $request->email,
    'password' => Hash::make($request->password), // bcrypt: $2y$12$...
]);
event(new Registered($user));
Auth::login($user); // loga automaticamente
```

| Passo | O que acontece | Se errar |
|-------|----------------|----------|
| `Hash::make('senha')` | Gera bcrypt irreversível | Sem `Hash` → senha em texto puro no banco |
| `Hash::check('senha', $user->password)` | Verifica no login | `password_verify` direto funciona, mas `Hash::check` é padrão |
| `remember_token` | Cookie "lembrar" 5 anos | Sem `rememberToken()` na migration → `Unknown column` |

**Proteção de rotas:**

```php
Route::middleware(['auth'])->group(function () {
    Route::get('/dashboard', fn()=>view('dashboard'))->name('dashboard');
    Route::get('/profile', [ProfileController::class,'edit']);
});
Route::middleware('guest')->group(function () {
    Route::get('/login', [AuthenticatedSessionController::class,'create']); // só deslogado
});
```

```php
auth()->user(); auth()->id(); Auth::check(); // logado?
auth()->logout(); $request->session()->invalidate(); // logout
```

## 17.5 Verificação de email, reset e throttling

```php
// User implements MustVerifyEmail
class User extends Authenticatable implements MustVerifyEmail {}
Route::get('/verify-email/{id}/{hash}', VerifyEmailController::class)->middleware(['auth','signed','throttle:6,1']);

// Reset: Breeze já cria PasswordResetLinkController + NewPasswordController
// Throttling: throttle:5,1 = 5 tentativas por minuto no login (bloqueia brute-force)
Route::post('/login', [AuthenticatedSessionController::class,'store'])->middleware('throttle:5,1');
```

| Recurso | Middleware/Coluna | Erro comum |
|---------|------------------|------------|
| Verificação | `MustVerifyEmail` + `verified` middleware | `Class User must implement MustVerifyEmail` → implemente |
| Reset | `password_reset_tokens` table | `SQLSTATE[42S02]: password_reset_tokens not found` → `php artisan migrate` |
| Throttling | `throttle:5,1` | `Too Many Attempts` → aguarde 1 min |
| Remember | `remember_token` + checkbox `remember` | Sem `rememberToken()` → `Unknown column` |

**Erros:**

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `Route [login] not defined` | Rota `login` não existe | Instale Breeze ou `Route::get('/login')->name('login')` |
| `These credentials do not match our records` | `Auth::attempt(['email'=>$r->email, 'password'=>$r->password])` falhou | `Hash::make` no registro? |
| `419 Page Expired` no login | `@csrf` faltando | Adicione `@csrf` no `<form>` |

> **Breeze vs Jetstream/Fortify:** Breeze = leve (Blade/Tailwind, auth simples). Jetstream = completo (teams, 2FA, Livewire/Inertia). Fortify = headless (só backend).

---

⬅️ [Anterior: Validação](./16-validacao.md) | ➡️ [18. Autorização](./18-autorizacao.md) | [Sumário](./README.md)
