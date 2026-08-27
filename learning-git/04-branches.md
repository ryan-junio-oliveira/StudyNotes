# 04. Branches — Ponteiros móveis (o coração do Git)

> Parte do [Curso Completo de Git](./README.md)

## 4.1 Branch não é cópia

Branch = **ponteiro** (arquivo `.git/refs/heads/main` com hash). Criar branch é instantâneo.

```
main  → a1b2c3  (commit)
        ↑
HEAD ───┘  (você está em main)
```

```bash
git branch feature/hero   # cria ponteiro para a1b2c3 (não muda de branch!)
git branch                # lista locais; * indica HEAD
git branch -a             # locais + remotos (origin/main)
git checkout feature/hero # ou git switch feature/hero (Git 2.23+) — move HEAD
# atalho: git checkout -b feature/hero / git switch -c feature/hero
```

## 4.2 Trabalhar isolado e mesclar

```bash
git checkout -b feature/hero
# edita style.css
git add style.css && git commit -m "style: improve hero"

git checkout main
git merge feature/hero
```

| Tipo de merge | Quando acontece | Grafo |
|---------------|-----------------|-------|
| **Fast-forward** | main não andou enquanto feature andou | `main` só anda o ponteiro → `*──●──●` linear |
| **Three-way** | ambos andaram | Cria commit de merge com 2 pais → `*──┬●` |

```bash
git merge --no-ff feature/hero  # força commit de merge mesmo se fast-forward (preserva contexto)
git branch -d feature/hero      # apaga local (seguro: só se já mergeada)
git branch -D feature/hero      # força apagar
```

## 4.3 Ver grafo

```bash
git log --oneline --graph --all --decorate
# * 8e2a1b (HEAD -> main) Merge branch 'feature/hero'
# |\
# | * a9c3d2 (feature/hero) style: improve hero
# |/
# * a1b2c3 feat: initial portfolio
```

> Use `git status` antes de branch para não carregar sujeira.

**Erro comum:**

```
fatal: A branch named 'feature/hero' already exists
→ já existe — use outro nome ou git branch -D

You are in 'detached HEAD' state
→ você fez checkout em commit, não branch — crie branch: git switch -c temp
```

---

⬅️ [Anterior: Staging](./03-staging-commit.md) | ➡️ [05. Remotos](./05-remotos.md) | [Sumário](./README.md)
