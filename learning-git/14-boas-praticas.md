# 14. Boas Práticas — Workflow diário

> Parte do [Curso Completo de Git](./README.md)

## Diário

```bash
git status && git pull --rebase  # começar limpo e atualizado
# ... codar ...
git add -p && git commit -m "feat: ..."  # commit atômico (uma ideia por commit)
git push
```

## Regras

- **Commit atômico:** 1 feat/fix por commit, não "wip" gigante.
- **`git status` antes de tudo** — sempre.
- **Nunca `add .` sem revisar** — `git diff --staged`.
- **`--force-with-lease` > `--force`**.
- **Main protegida:** PR + review, nunca direto.

## Referência rápida

| Comando | Quando |
|---------|--------|
| `git status` | Antes/depois de tudo |
| `git log --oneline --graph --all` | Entender histórico |
| `git diff` / `diff --staged` | O que vai commitar |
| `git fetch && git log HEAD..origin/main` | O que mudou no remoto |

---

⬅️ [Anterior: Projeto Portfolio](./13-projeto-portfolio.md) | ➡️ [15. Worktree](./15-worktree-submodule.md) | [Sumário](./README.md)
