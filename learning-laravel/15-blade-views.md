# 15. Blade — Views (dissecado)

> Parte do [Curso Completo de Laravel](./README.md)
> **Blade = HTML com superpoderes:** `{{ }}` escapa XSS, `@if`/`@foreach`, herança de layout e componentes.

## 15.1 Layout + herança (`@extends`/`@section`)

```blade
{{-- resources/views/layouts/app.blade.php --}}
<html><head><title>@yield('title','Blog')</title></head>
<body>
  <nav>...</nav>
  @yield('content') {{-- buraco que filho preenche --}}
</body></html>

{{-- resources/views/posts/index.blade.php --}}
@extends('layouts.app') {{-- 1. Herda layout --}}
@section('title','Posts') {{-- 2. Preenche title --}}
@section('content') {{-- 3. Preenche content --}}
  @foreach($posts as $post)
    <h2>{{ $post->titulo }}</h2> {{-- 4. Escapado (seguro) --}}
    <p>{{ Str::limit($post->conteudo, 100) }}</p>
    <a href="{{ route('posts.show', $post) }}">Ver</a>
  @endforeach
  {{ $posts->links() }} {{-- paginação (cap. 20) --}}
@endsection
```

| Diretiva | O que faz | Se errar |
|----------|-----------|----------|
| `@extends('layouts.app')` | Usa layout pai | `View [layouts.app] not found` → arquivo deve estar em `resources/views/layouts/app.blade.php` |
| `@yield('content')` / `@section('content')` | Buraco / preenchimento | `@section` sem `@endsection` → Blade fal |
| `{{ $var }}` | Escapa HTML (`<script>` → `&lt;script&gt;`) | XSS seguro |
| `{!! $html !!}` | **Não** escapa (HTML cru) | XSS se vier do usuário! |
| `@csrf` | Token CSRF no `<form>` | Sem ele → `419 Page Expired` |

## 15.2 `@if`/`@foreach`/`@auth` e componentes

```blade
@auth <p>Olá {{ auth()->user()->name }}</p> @else <a href="{{ route('login') }}">Login</a> @endauth
@forelse($posts as $post) <x-post-card :post="$post" /> @empty <p>Nenhum post</p> @endforelse
@error('titulo') <span class="error">{{ $message }}</span> @enderror
```

**Componente:**

```bash
php artisan make:component Alert
# Cria app/View/Components/Alert.php + resources/views/components/alert.blade.php
```

```blade
{{-- components/alert.blade.php --}}
<div class="alert alert-{{ $type }}">{{ $slot }}</div>
{{-- Uso --}}
<x-alert type="success">Post criado!</x-alert>
<x-alert type="danger" :message="$errors->first('titulo')" />
```

> **Dica:** Blade compila para PHP puro em `storage/framework/views/` — `php artisan view:clear` limpa cache.

---

⬅️ [Anterior: Rotas](./14-rotas-controllers.md) | ➡️ [16. Validação](./16-validacao.md) | [Sumário](./README.md)
