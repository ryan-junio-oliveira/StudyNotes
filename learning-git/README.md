# Curso Completo de Git — Do Zero ao Avançado

> **Projeto fio-condutor: Portfolio estático em `projeto-portfolio/`**. Cada capítulo adiciona commits, branches e PRs no mesmo repo — como aprenderia em um time real.

**Como usar:** leia em ordem, execute no `/tmp/portfolio` copiado de `projeto-portfolio/`. Todo exemplo assume MySQL não, só Git + GitHub.

---

## 📚 Sumário do Curso

| # | Capítulo | Conteúdo | Arquivo |
|---|----------|----------|---------|
| 01 | **Introdução** | Distribuído vs centralizado, snapshots, 3 estados, `.git/` e branch como ponteiro | [01-introducao.md](./01-introducao.md) |
| 02 | **Configuração, init, clone, .gitignore** | `config` scopes, `init`/`clone`, `.gitignore` + `check-ignore` | [02-configuracao.md](./02-configuracao.md) |
| 03 | **Staging, commit e histórico** | Ciclo `add`/`commit`, `status`/`diff`/`log`/`show`, `rm --cached` | [03-staging-commit.md](./03-staging-commit.md) |
| 04 | **Branches** | Ponteiros, `HEAD`, `switch`/`checkout`, fast-forward vs 3-way, grafo | [04-branches.md](./04-branches.md) |
| 05 | **Remotos** | `origin`, `push`/`fetch`/`pull`, `upstream`, `--force-with-lease` | [05-remotos.md](./05-remotos.md) |
| 06 | **Conflitos** | Marcadores `<<<<<<<`, `git add` após resolver, `merge --abort` | [06-conflitos.md](./06-conflitos.md) |
| 07 | **Desfazer** | `reset` soft/mixed/hard, `restore`, `revert`, `reflog`, `amend` | [07-desfazer.md](./07-desfazer.md) |
| 08 | **Rebase, Stash, Cherry-pick** | `rebase` vs `merge`, `stash` gaveta, `cherry-pick`, `bisect` | [08-rebase-stash.md](./08-rebase-stash.md) |
| 09 | **Tags** | Leve vs anotada, SemVer, `push --tags` | [09-tags.md](./09-tags.md) |
| 10 | **Convenções** | Conventional Commits, aliases, `clean` | [10-convencoes.md](./10-convencoes.md) |
| 11 | **GitHub Flow** | `feature → PR → squash merge`, fork, branch protection | [11-github-flow.md](./11-github-flow.md) |
| 12 | **SSH, LFS e Hooks** | `ed25519` por OS, `git lfs`, `pre-commit` hook | [12-ssh-lfs-hooks.md](./12-ssh-lfs-hooks.md) |
| 13 | **Projeto Portfolio (lab)** | Passo a passo que amarra caps. 03–09 no `/tmp/portfolio` | [13-projeto-portfolio.md](./13-projeto-portfolio.md) |
| 14 | **Boas Práticas** | Workflow diário, referência rápida `status`/`log`/`diff` | [14-boas-praticas.md](./14-boas-praticas.md) |

### 📦 Projeto

| Arquivo | Descrição |
|---------|-----------|
| [`projeto-portfolio/index.html`](./projeto-portfolio/index.html) | HTML base do lab |
| [`projeto-portfolio/style.css`](./projeto-portfolio/style.css) | CSS base do lab |

---

## 🗺️ Trilha

```
01 Introdução (3 estados, .git)
   ↓
02 Config → 03 Staging/commit → 04 Branches → 05 Remotos
   ↓
06 Conflitos → 07 Desfazer → 08 Rebase/Stash
   ↓
09 Tags → 10 Convenções → 11 GitHub Flow → 12 SSH/LFS/Hooks
   ↓
13 Lab Portfolio (amarra tudo) → 14 Boas Práticas
```

Comece por [01. Introdução](./01-introducao.md) →
