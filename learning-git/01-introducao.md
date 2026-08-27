# 01. Introdução — O que é Git (começando do zero)

> Parte do [Curso Completo de Git](./README.md) — Projeto **portfolio** em `projeto-portfolio/`
> **Para quem nunca usou versionamento.** Se já fez `git init`, pule para [02](./02-configuracao.md).

## 1.1 Sem Git vs com Git

| Sem Git | Com Git |
|---------|---------|
| `portfolio_v1.zip`, `portfolio_v2_final.zip`, `portfolio_FINAL2.zip` | Um diretório com histórico: `git log` mostra **quem**, **quando** e **por quê** mudou cada linha |
| "Medo de apagar" — Ctrl+Z não volta | `git revert` ou `git reflog` desfaz qualquer coisa |
| Sem internet = sem histórico (SVN) | **Distribuído**: todo `clone` tem histórico completo em `.git/` |

## 1.2 Centralizado vs distribuído

```
SVN (centralizado):  seu PC ──► servidor (histórico só lá) ── sem internet = sem commit
Git (distribuído):   seu PC (.git completo) ──► GitHub (.git completo) ── sem internet = commit local, depois push
```

> Por isso `git log` funciona offline — histórico está no seu disco.

## 1.3 Snapshots, não diferenças

Git não guarda "o que mudou", guarda **foto (snapshot)** do projeto a cada `commit` + ponteiro para o pai:

```
commit a1b2c3 (HEAD -> main)  foto de index.html + style.css em 27/08 14:00
  ↑ pai
commit 9f8e7d  foto anterior (só style.css diferente)
```

Se um arquivo não mudou, Git reaproveita o blob — eficiente.

## 1.4 Os 3 estados — a ideia que explica 80% das confusões

```
Working Directory  ── git add ──►  Staging Area (Index)  ── git commit ──►  Repository (.git)
   (seus arquivos)                (palco)                              (histórico imutável)
     └──────────── git status mostra onde cada arquivo está ────────────┘
```

| Estado | Onde | O que é |
|--------|------|---------|
| **Working** | Disco (`index.html` editado) | O que você está mexendo agora |
| **Staging** | Área de preparo (`git add` colocou lá) | O que **vai** no próximo commit (você escolhe: `git add index.html` só, não `style.css`) |
| **Repository** | `.git/objects` | O que já foi **congelado** (imutável, com hash `a1b2c3`) |

**Analogia:** Working = cozinha, Staging = bandeja que você monta, Repository = foto da bandeja guardada no álbum.

## 1.5 O que é `.git/`?

`git init` cria `portfolio/.git/`:

```
.git/objects/           ← todos os commits/blobs (fotos)
.git/refs/heads/main    ← arquivo texto com hash do último commit de main (branch é só ponteiro!)
.git/HEAD               ← onde você está: "ref: refs/heads/main" (ou hash em detached HEAD)
```

> **Branch não é pasta** — é **post-it móvel** apontando para um commit. Criar branch é criar um arquivo de 41 bytes.

## 1.6 Glossário mínimo (volte aqui quando esquecer)

| Termo | Significado simples | Exemplo |
|-------|---------------------|---------|
| **Repository (repo)** | Pasta com `.git/` | `/tmp/portfolio` |
| **Commit** | Foto + mensagem + autor + pai | `a1b2c3 "feat: add hero"` |
| **Branch** | Ponteiro móvel para commit | `main → a1b2c3`, `feature/hero → 8e2a1b` |
| **HEAD** | Onde você está (ponteiro para branch ou commit) | `HEAD → main` vs `HEAD → a1b2c3` (detached) |
| **Working Directory** | Arquivos no disco | `index.html` editado |
| **Staging / Index** | Palco do próximo commit | `git add index.html` foi para lá |
| **Remote / origin** | Apelido para URL do GitHub | `origin → git@github.com:user/repo.git` |
| **Clone** | Baixar `.git` inteiro | `git clone <url>` |

---

⬅️ [Sumário](./README.md) | ➡️ [02. Configuração e init](./02-configuracao.md)
