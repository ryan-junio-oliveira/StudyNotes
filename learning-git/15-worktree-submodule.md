# 15. Worktree, Sparse-Checkout e Submodules

> Parte do [Curso Completo de Git](./README.md)

## 15.1 `git worktree` — múltiplas pastas, um `.git`

> Uma branch por pasta, sem `stash` toda hora.

```bash
git worktree list
git worktree add ../portfolio-hotfix hotfix/urgente  # cria ../portfolio-hotfix na branch hotfix
# edite ../portfolio-hotfix, commit, push
git worktree remove ../portfolio-hotfix
```

| `worktree` vs `clone` | worktree compartilha `.git` (leve, 1 fetch para todos) |
| `checkout` | só uma branch por vez na mesma pasta |

## 15.2 `sparse-checkout` — monorepo parcial

```bash
git clone --sparse https://github.com/user/monorepo.git
git sparse-checkout set portfolio/   # só baixa portfolio/, não docs/
git sparse-checkout list
```

## 15.3 Submodule vs Subtree

```bash
# Submodule: repo dentro de repo (ponteiro para commit externo)
git submodule add https://github.com/user/lib.git vendor/lib
git submodule update --init --recursive
# Ao clonar com submodules: git clone --recurse-submodules

# Subtree: copia histórica para dentro (sem .git separado)
git subtree add --prefix=vendor/lib https://github.com/user/lib.git main --squash
```

|  | Submodule | Subtree |
|--|-----------|---------|
| `.git` extra | Sim (`vendor/lib/.git`) | Não |
| Atualizar | `git submodule update --remote` | `git subtree pull` |
| Quando usar | Vendor com release próprio | Vendor que você modifica junto |

> Monorepo pequeno → `sparse-checkout`. Vendor externo → `submodule` se quer rastrear upstream.

---

⬅️ [Anterior: Boas Práticas](./14-boas-praticas.md) | ➡️ [16. Patches e Bundle](./16-patches-bundle.md) | [Sumário](./README.md)
