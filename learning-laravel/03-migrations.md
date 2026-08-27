# 03. Migrations — DDL Versionado (dissecado linha a linha)

> Parte do [Curso Completo de Laravel](./README.md)
> **Migration = `CREATE TABLE` em PHP, versionado no Git.** `php artisan migrate` aplica, `migrate:rollback` desfaz.

## 3.1 Anatomia de uma migration (SQL vs Blueprint)

**SQL puro (o que o banco executa):**

```sql
CREATE TABLE posts (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, titulo VARCHAR(150) NOT NULL);
```

**Blueprint (o que você escreve):** mesmo significado, em PHP legível e portável:

```php
// database/migrations/2024_01_01_000001_create_posts_table.php
return new class extends Migration {
    public function up(): void {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();                      // ← BIGINT PK
            $table->string('titulo', 150);     // ← VARCHAR(150)
        });
    }
    public function down(): void {
        Schema::dropIfExists('posts');         // ← desfaz (rollback)
    }
};
```

| Parte | O que significa | Se omitir/errar |
|-------|-----------------|-----------------|
| `new class extends Migration` | Classe anônima (Laravel 8+) | Classe nomeada também funciona |
| `up()` | O que faz ao `migrate` | Vazio → nada cria |
| `down()` | O que faz ao `rollback` | Vazio → `rollback` não apaga |
| `Schema::create('posts', fn)` | Cria tabela `posts` | Nome errado → `Post` model não encontra (`protected $table`) |

> **Por que não SQL puro?** Time todo roda `migrate`, histórico no Git, `migrate:fresh --seed` recria do zero em qualquer env.

## 3.2 Criando migrations (sintaxe dissecada)

```bash
php artisan make:migration create_posts_table              # vazio (você escreve Schema::create)
php artisan make:migration create_posts_table --create=posts # já vem com Schema::create('posts')
php artisan make:migration add_slug_to_posts_table --table=posts # já vem com Schema::table('posts')
```

| Comando | Gera | Quando usar |
|---------|------|-------------|
| `make:migration create_X` | `Schema::create('X')` | Nova tabela |
| `make:migration add_Y_to_Z --table=Z` | `Schema::table('Z')` com `up`/`down` | Adicionar coluna em tabela existente |
| `make:migration create_X --create=X` | Igual, já com esqueleto | Atalho para tabela nova |

**Ordem de criação importa:** `2024_01_01_000001_users`, `000002_posts` — `posts` com `user_id FK` precisa de `users` já criado.

## 3.3 `Schema::create('posts')` dissecado (Blog)

```php
Schema::create('posts', function (Blueprint $table) {
    $table->id(); // 1. PK BIGINT UNSIGNED AUTO_INCREMENT (alias bigIncrements) — PK do cap. 02
    $table->string('titulo', 150); // 2. VARCHAR(150) NOT NULL — título obrigatório
    $table->string('slug')->unique(); // 3. VARCHAR(255) UNIQUE — URL /posts/meu-post
    $table->text('conteudo'); // 4. TEXT — longo, sem limite
    $table->foreignId('user_id')->constrained()->onDelete('cascade'); // 5. FK → users.id + CASCADE
    $table->foreignId('category_id')->nullable()->constrained()->nullOnDelete(); // 6. FK opcional → null ao apagar category
    $table->boolean('ativo')->default(true); // 7. TINYINT DEFAULT 1 — rascunho vs publicado
    $table->timestamp('publicado_em')->nullable(); // 8. TIMESTAMP NULL — quando publicou
    $table->timestamps(); // 9. created_at + updated_at (gerenciado pelo Eloquent, ver cap. 05)
    $table->softDeletes(); // 10. deleted_at (cap. 10) — exclusão lógica
});
```

| Linha | Equivalência SQL | O que faz | Se errar |
|-------|-----------------|-----------|----------|
| `$table->id()` | `id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY` | PK do Blog (cap. 02) | Sem PK → Eloquent exige `protected $primaryKey = 'codigo'` |
| `->unique()` | `UNIQUE KEY` | `slug` não repete | `Duplicate entry 'meu-post'` ao repetir |
| `foreignId()->constrained()` | `user_id BIGINT UNSIGNED, FOREIGN KEY REFERENCES users(id)` | FK → `users.id` | `Cannot add foreign key` se `users` não existe ainda |
| `->onDelete('cascade')` | `ON DELETE CASCADE` | Se apaga `user`, apaga `posts` dele | `restrict` bloqueia delete de user com posts |
| `->nullable()` | `DEFAULT NULL` | Aceita `NULL` | Sem ele, `Field 'category_id' doesn't have a default value` ao omitir |
| `$table->timestamps()` | `created_at TIMESTAMP, updated_at TIMESTAMP` | Eloquent preenche auto | Sem ele, `public $timestamps = false` no Model |
| `$table->softDeletes()` | `deleted_at TIMESTAMP NULL` | `SoftDeletes` (cap. 10) | Sem ele, `delete()` apaga de verdade |

**Visual com dados (cap. 02):**

```
users (PK id=1) ◄── foreignId('user_id')->constrained() ── posts (FK user_id=1)
```

## 3.4 Todos os tipos (referência rápida)

```php
Schema::create('exemplo', function (Blueprint $table) {
    $table->id(); $table->uuid('uuid')->primary();
    $table->tinyInteger('tiny'); $table->smallInteger('small'); $table->integer('normal');
    $table->bigInteger('big'); $table->decimal('preco', 8, 2); // 8 dígitos, 2 decimais
    $table->boolean('ativo')->default(true); // TINYINT(1)
    $table->char('letra', 1); $table->string('nome', 100);
    $table->text('descricao'); $table->mediumText('m'); $table->longText('l');
    $table->date('nasc'); $table->datetime('inicio'); $table->timestamp('criado')->nullable();
    $table->json('config'); $table->enum('status', ['rascunho','publicado']);
    $table->ipAddress('ip'); $table->rememberToken(); $table->timestamps();
});
```

> **Dica:** `string` com limite (`100`) vs `text` sem limite — como em SQL (`04-tipos-constraints.md:7`).

## 3.5 Índices e FKs avançados (quando `constrained()` não basta)

```php
$table->string('email')->unique(); // índice único
$table->index('titulo'); // índice simples
$table->index(['category_id', 'created_at']); // composto (ordem importa)
$table->fullText('conteudo'); // busca textual MySQL 5.7+

// FK explícita (nome fora da convenção user_id → users.id)
$table->unsignedBigInteger('perfil_id');
$table->foreign('perfil_id')->references('id')->on('perfis')->onDelete('restrict');
```

| `constrained()` | `foreign()->references()->on()` |
|-----------------|-------------------------------|
| Convenção `user_id → users.id` | Nome custom `perfil_id → perfis.id` |

## 3.6 `Schema::table` — alterar sem apagar dados (evolução)

```php
Schema::table('posts', function (Blueprint $table) {
    $table->string('resumo', 255)->nullable()->after('titulo'); // adiciona depois de titulo
    $table->dropColumn('conteudo_antigo'); // remove
    // $table->renameColumn('titulo', 'titulo_completo'); // requer doctrine/dbal
});
```

> **Migrations são incrementais:** cada `make:migration` é um commit do banco. Nunca edite uma já rodada em produção — crie nova `add_...`.

## 3.7 Comandos Artisan (tabela + erros)

| Comando | O que faz | Quando | Risco |
|---------|-----------|--------|-------|
| `migrate` | Aplica pendentes | Deploy | Seguro |
| `migrate:rollback` | Desfaz último batch (grupo) | Errou migration | Desfaz só último lote |
| `migrate:reset` | Desfaz todas | Raro | Perde tudo |
| `migrate:fresh --seed` | **Apaga tudo** + recria + seed | Dev | **Perde dados!** |
| `migrate:status` | Lista `Ran`/`Pending` | Debug | — |
| `migrate --pretend` | Mostra SQL sem executar | Preview | — |

**Erros comuns:**

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `Cannot add foreign key constraint` | FK antes do pai (`posts` antes de `users`) | Renomeie timestamp da migration ou use `Schema::table` depois |
| `Duplicate column name 'slug'` | `add_slug` já existe | `Schema::hasColumn('posts','slug')` ou `migrate:rollback` |
| `Nothing to migrate` | Sem migrations pendentes | `migrate:status` para conferir |
| `Class PostSeeder not found` | `composer dump-autoload` | `composer dump-autoload` |

---

⬅️ [Anterior: Projeto Blog](./02-projeto-blog.md) | ➡️ [04. Seeders e Factories](./04-seeders-factories.md) | [Sumário](./README.md)
