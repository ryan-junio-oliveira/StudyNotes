# 11. GitHub Flow — Branches, PR e Code Review

> Parte do [Curso Completo de Git](./README.md)

## 11.1 Fluxo simples (recomendado para solo/pequeno time)

```
main (protegida) ◄── feature/hero ──┐
     ↑                               │ PR → review → squash merge → delete branch
     └───────────────────────────────┘
```

```bash
git checkout -b feature/hero
git commit -m "feat: add hero" && git push -u origin feature/hero
# GitHub → Compare & pull request → Review → Merge (squash)
git checkout main && git pull --prune
```

## 11.2 Fork + PR (open source)

```bash
# 1. Fork no GitHub (botão Fork)
git clone git@github.com:seu-user/repo.git
git remote add upstream git@github.com:original/repo.git
git fetch upstream && git checkout -b fix/typo upstream/main
# commit, push para seu fork
git push origin fix/typo
# PR: seu fork → original
```

## 11.3 Proteção

- `Settings → Branches → Add rule → Require pull request reviews, Require status checks`
- Nunca `push --force` em `main` — use `revert` (cap. 07).

---

⬅️ [Anterior: Convenções](./10-convencoes.md) | ➡️ [12. SSH, LFS e Hooks](./12-ssh-lfs-hooks.md) | [Sumário](./README.md)
