# 03. Migrations — DDL Versionado (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 3.1 O que são Migrations?

> **Migration = `CREATE TABLE` em PHP, versionado no Git.** `php artisan migrate` aplica, `rollback` desfaz.

```php
// database/migrations/2024_01_01_000001_create_posts_table.php
return new class extends Migration {
    public function up(): void { /* cria */ }
    public function down(): void { /* desfaz */ }
};
```

**Por que não SQL puro?** Time todo roda `migrate`, histórico no Git, `migrate:fresh --seed` recria do zero.

## 3.2 Criando migrations (sintaxe dissecada)

```bash
php artisan make:migration create_posts_table              # cria vazio
php artisan make:migration create_posts_table --create=posts # já vem com Schema::create
php artisan make:migration add_slug_to_posts_table --table=posts # alteração
php artisan make:migration add_slug_to_posts_table --table=posts
```

| Comando | Gera |
|---------|------|
| `make:migration create_X` | `Schema::create('X')` |
| `make:migration add_Y_to_Z --table=Z` | `Schema::table('Z')` com `up`/`down` |

## 3.3 `Schema::create` dissecado (projeto Blog)

```php
Schema::create('posts', function (Blueprint $table) {
    $table->id(); // 1. PK BIGINT UNSIGNED AUTO_INCREMENT (alias para bigIncrements)
    $table->string('titulo', 150); // 2. VARCHAR(150) NOT NULL
    $table->string('slug')->unique(); // 3. UNIQUE (para URL /posts/meu-post)
    $table->text('conteudo'); // 4. TEXT
    $table->foreignId('user_id')->constrained()->onDelete('cascade'); // 5. FK → users.id
    $table->foreignId('category_id')->nullable()->constrained()->nullOnDelete(); // 6. FK opcional
    $table->boolean('ativo')->default(true); // 7. DEFAULT true
    $table->timestamp('publicado_em')->nullable(); // 8. nullable
    $table->timestamps(); // 9. created_at + updated_at (gerenciado pelo Eloquent)
    $table->softDeletes(); // 10. deleted_at (cap. 11)
});
```

| Linha | O que faz | Se errar |
|-------|-----------|----------|
| `$table->id()` | PK `bigIncrements` | Sem PK → Eloquent exige `protected $primaryKey` |
| `->unique()` | Trava `UNIQUE` | `Duplicate entry 'meu-post'` ao repetir slug |
| `foreignId()->constrained()` | `BIGINT UNSIGNED` + `FOREIGN KEY REFERENCES users(id)` | `Cannot add foreign key` se `users` não existe ainda (ordem importa!) |
| `->onDelete('cascade')` | Se apaga user, apaga posts | `restrict` bloqueia delete de user com posts |
| `->nullable()` | Aceita `NULL` | Sem ele, `Field doesn't have a default value` |
| `$table->timestamps()` | Cria `created_at`, `updated_at` | Eloquent espera, senão `public $timestamps = false` |
| `$table->softDeletes()` | `deleted_at` para exclusão lógica | Sem ele, `SoftDeletes` falha |

**Ordem importa:** `users` e `categories` antes de `posts` (FK precisa do pai).

## 3.4 Todos os tipos (referência)

```php
Schema::create('exemplo', function (Blueprint $table) {
    $table->id(); $table->uuid('uuid')->primary();
    $table->tinyInteger('tiny'); $table->smallInteger('small'); $table->integer('normal');
    $table->bigInteger('big'); $table->decimal('preco', 8, 2);
    $table->boolean('ativo')->default(true);
    $table->char('letra', 1); $table->string('nome', 100);
    $table->text('descricao'); $table->mediumText('m'); $table->longText('l');
    $table->date('nasc'); $table->datetime('inicio'); $table->timestamp('criado')->nullable();
    $table->json('config'); $table->enum('status', ['rascunho','publicado']);
    $table->ipAddress('ip'); $table->rememberToken(); $table->timestamps();
});
```

## 3.5 Índices e FKs avançados

```php
$table->string('email')->unique();
$table->index('titulo');
$table->index(['category_id', 'created_at']); // composto
$table->fullText('conteudo'); // MySQL 5.7+

// FK explícita (quando nome não segue convenção)
$table->unsignedBigInteger('perfil_id');
$table->foreign('perfil_id')->references('id')->on('perfis')->onDelete('restrict');
```

## 3.6 `Schema::table` — alterar sem apagar dados

```php
Schema::table('posts', function (Blueprint $table) {
    $table->string('resumo', 255)->nullable()->after('titulo');
    $table->dropColumn('conteudo_antigo');
    // $table->renameColumn('titulo', 'titulo_completo'); // requer doctrine/dbal
});
```

## 3.7 Comandos Artisan (tabela)

| Comando | O que faz | Quando |
|---------|-----------|--------|
| `migrate` | Aplica pendentes | Deploy |
| `migrate:rollback` | Desfaz último batch | Errou migration |
| `migrate:reset` | Desfaz todas | Raro |
| `migrate:fresh --seed` | Apaga tudo + recria + seed | Dev (perde dados!) |
| `migrate:status` | Lista aplicadas | Debug |
| `migrate:fresh --seed` | + seeders (cap. 04) | Reset com dados fake |

> **Regra:** nunca edite migration já rodada em produção — crie nova `add_...`.

---

⬅️ [Anterior: Projeto Blog](./02-projeto-blog.md) | ➡️ [04. Seeders e Factories](./04-seeders-factories.md) | [Sumário](./README.md)
