
# 🧱 TUTORIAL DEFINITIVO: MIGRATIONS NO LARAVEL

## 📌 SUMÁRIO
1. [Conceito e Estrutura](#1)
2. [Criação de Migrations](#2)
3. [Tipos de Colunas](#3)
4. [Chaves Primárias, Únicas, Índices e Fulltext](#4)
5. [Relacionamentos (foreign keys)](#5)
6. [Modificações com `Schema::table`](#6)
7. [Triggers (via SQL Raw)](#7)
8. [Comandos Artisan úteis](#8)
9. [Boas práticas e dicas](#9)

---

<a name="1"></a>
## ✅ 1. O que são Migrations?
Migrations são arquivos versionáveis que definem a estrutura do banco de dados da sua aplicação em Laravel.

---

<a name="2"></a>
## 🛠️ 2. Criando Migrations

```bash
php artisan make:migration create_nome_tabela_table
php artisan make:migration add_coluna_to_tabela_table --table=tabela
```

---

<a name="3"></a>
## 🧱 3. TODOS os tipos de colunas disponíveis

```php
Schema::create('exemplo', function (Blueprint $table) {
    $table->id();
    $table->uuid('uuid')->primary();
    $table->tinyInteger('tiny');
    $table->smallInteger('small');
    $table->mediumInteger('medium');
    $table->integer('normal');
    $table->bigInteger('big');
    $table->unsignedInteger('unsigned');
    $table->float('float', 8, 2);
    $table->double('double', 15, 8);
    $table->decimal('decimal', 8, 2);
    $table->boolean('ativo')->default(true);
    $table->char('letra', 1);
    $table->string('nome', 100);
    $table->text('descricao');
    $table->mediumText('texto_medio');
    $table->longText('texto_longo');
    $table->date('data_nascimento');
    $table->datetime('inicio');
    $table->timestamp('criado_em')->nullable();
    $table->time('hora');
    $table->year('ano');
    $table->json('configuracoes');
    $table->jsonb('dados');
    $table->enum('status', ['ativo', 'inativo', 'pendente']);
    $table->set('permissoes', ['ler', 'escrever', 'editar'])->nullable();
    $table->ipAddress('ip');
    $table->macAddress('mac');
    $table->rememberToken();
    $table->timestamps();
});
```

---

<a name="4"></a>
## 🧩 4. Índices, Uniques, Fulltext, Primary

```php
$table->string('email')->unique();
$table->index('nome');
$table->primary('uuid');
$table->fullText('descricao');
$table->unique(['coluna1', 'coluna2']);
$table->index(['categoria_id', 'created_at']);
```

---

<a name="5"></a>
## 🔗 5. Chaves estrangeiras (Relacionamentos)

```php
$table->foreignId('user_id')->constrained();
$table->foreignId('user_id')->constrained('usuarios', 'codigo');
$table->foreignId('categoria_id')->constrained()->onDelete('cascade')->onUpdate('cascade');
$table->unsignedBigInteger('perfil_id');
$table->foreign('perfil_id')->references('id')->on('perfis')->onDelete('restrict');
```

---

<a name="6"></a>
## 🔄 6. Alterando Tabelas com `Schema::table`

```php
Schema::table('users', function (Blueprint $table) {
    $table->string('avatar')->nullable()->after('email');
    $table->dropColumn('telefone');
    $table->renameColumn('nome', 'nome_completo');
});
```

---

<a name="7"></a>
## 🔥 7. TRIGGERS no Laravel (via SQL Raw)

```php
use Illuminate\Support\Facades\DB;

public function up(): void
{
    DB::unprepared('
        CREATE TRIGGER trigger_nome
        BEFORE INSERT ON posts
        FOR EACH ROW
        BEGIN
            SET NEW.slug = LOWER(REPLACE(NEW.title, " ", "-"));
        END
    ');
}

public function down(): void
{
    DB::unprepared('DROP TRIGGER IF EXISTS trigger_nome');
}
```

---

<a name="8"></a>
## 🧪 8. Comandos Artisan úteis

| Comando | Função |
|--------|--------|
| `php artisan migrate` | Aplica as migrations |
| `php artisan migrate:rollback` | Desfaz a última "batch" |
| `php artisan migrate:reset` | Desfaz todas |
| `php artisan migrate:fresh` | Apaga tudo e recria |
| `php artisan migrate:refresh` | Reverte e aplica novamente |
| `php artisan migrate:status` | Lista o status das migrations |
| `php artisan schema:dump` | Gera dump para otimizar instalação |

---

<a name="9"></a>
## 🧼 9. Boas Práticas

- Use `foreignId()->constrained()` sempre que possível.
- Nunca edite uma migration aplicada em produção.
- Nomeie claramente suas migrations.
- Evite lógica condicional complexa dentro de migrations.
- Comente trechos que envolvem SQL raw.
- Use seeders e factories junto com `--seed`.
