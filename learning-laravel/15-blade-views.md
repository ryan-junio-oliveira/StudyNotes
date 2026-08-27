# 15. Blade — Views (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)

## 15.1 Blade básico

```blade
{{-- resources/views/posts/index.blade.php --}}
@extends('layouts.app') {{-- 1. Herda layout --}}
@section('content')     {{-- 2. Preenche @yield('content') --}}
@foreach($posts as $post) {{-- 3. Loop --}}
  <h2>{{ $post->titulo }}</h2> {{-- 4. Escapado (seguro XSS) --}}
  {!! $post->conteudo !!}      {{-- 5. Não escapado (HTML) --}}
  @if($post->ativo) <span>Ativo</span> @endif
@endforeach
{{ $posts->links() }} {{-- paginação --}}
@endsection
```

| Diretiva | O que faz | Se errar |
|----------|-----------|----------|
| `{{ $var }}` | Escapa HTML | `{{ $post->titulo }}` sem `$post` → `Undefined variable` |
| `{!! $html !!}` | Não escapa | XSS se vier do usuário |
| `@extends`/`@section` | Layout | `@yield` sem `@section` → vazio |

## 15.2 Componentes (Laravel 7+)

```bash
php artisan make:component Alert
```

```blade
{{-- resources/views/components/alert.blade.php --}}
<div class="alert alert-{{ $type }}">{{ $slot }}</div>

{{-- Uso --}}
<x-alert type="success">Post criado!</x-alert>
```

> **Erro:** `View [posts.index] not found` → arquivo deve estar em `resources/views/posts/index.blade.php`.

---

⬅️ [Anterior: Rotas](./14-rotas-controllers.md) | ➡️ [16. Validação](./16-validacao.md) | [Sumário](./README.md)
