# 04. Branches — Ponteiros móveis e HEAD (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 4.1 Branch não é cópia (é post-it)

Branch = **arquivo texto** `.git/refs/heads/main` com 41 bytes (hash). Criar branch é instantâneo, não duplica arquivos.

```
.git/refs/heads/main  →  a1b2c3
.git/refs/heads/feature/hero → a1b2c3 (mesmo commit inicialmente)
```

**Visual antes e depois de `git branch feature/hero`:**

```
Antes:  main → a1b2c3  (commit)
        HEAD ──► main

Depois: main → a1b2c3
        feature/hero → a1b2c3
        HEAD ──► main  (você ainda está em main!)
```

```bash
git branch feature/hero   # cria ponteiro, não muda de branch!
git branch                # lista locais; * indica onde HEAD está
git branch -a             # locais + remotos (origin/main em vermelho)
git branch -vv            # mostra tracking e último commit
```

**Criar e trocar:**

```bash
git checkout feature/hero          # antigo (ainda funciona, mas faz checkout de arquivo também)
git switch feature/hero            # moderno (Git 2.23+), só branch
git checkout -b feature/hero       # cria e troca (antigo)
git switch -c feature/hero         # cria e troca (moderno)
# Prefira switch: erro "pathspec did not match" não confunde com branch
```

## 4.2 HEAD e detached HEAD

```
HEAD → main → a1b2c3  (normal: HEAD aponta para branch)

git checkout a1b2c3  →  HEAD → a1b2c3  (detached HEAD: HEAD aponta direto para commit, sem branch)
```

> **Detached HEAD:** você não está em branch — commit novo fica órfão. Saia criando branch: `git switch -c temp`.

**Ver onde está:**

```bash
cat .git/HEAD               # ref: refs/heads/main  ou hash
git status                  # HEAD detached at a1b2c3
```

## 4.3 Trabalhar isolado e tipos de merge (visual)

```bash
git switch -c feature/hero
# edita style.css
git add style.css && git commit -m "style: improve hero"  # feature/hero → a9c3d2

git switch main
git merge feature/hero
```

| Tipo | Quando acontece | Grafo | Ponteiro main |
|------|-----------------|-------|---------------|
| **Fast-forward** | `main` não andou enquanto `feature` andou | `main` só anda: `*──●──●` linear | `main → a9c3d2` (mesmo que feature) |
| **Three-way (merge commit)** | Ambos andaram (divergiram) | `*──┬─M` com 2 pais | `main → M` (novo commit com 2 pais) |

```
Fast-forward:  main: a1b2c3  →  main: a9c3d2 (feature)
Three-way:     main: a1b2c3──x──M
                        └─ a9c3d2 (feature) ─┘
```

```bash
git merge --no-ff feature/hero  # força commit M mesmo se fast-forward (preserva contexto de feature)
git branch -d feature/hero      # apaga local (seguro: só se já mergeada)
git branch -D feature/hero      # força apagar (perde commits não mergeados)
```

**Ver grafo (use sempre):**

```bash
git log --oneline --graph --all --decorate
# * 8e2a1b (HEAD -> main) Merge branch 'feature/hero'
# |\
# | * a9c3d2 (feature/hero) style: improve hero
# |/
# * a1b2c3 feat: initial portfolio
```

## 4.4 Erros comuns

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `fatal: A branch named 'feature/hero' already exists` | Já existe | `git branch -D` ou outro nome |
| `You are in 'detached HEAD' state` | `checkout` em commit, não branch | `git switch -c temp` |
| `error: path 'style.css' is unmerged` | Conflito não resolvido | Resolva, `git add`, `git commit` (cap. 06) |
| `Cannot delete branch 'main' checked out at ...` | Tentou apagar onde está | `git switch outra` antes |

> **Regra:** comece branch com `main` limpo (`git status` clean) — sujeira vai junto.

---

⬅️ [Anterior: Staging](./03-staging-commit.md) | ➡️ [05. Remotos](./05-remotos.md) | [Sumário](./README.md)
