# 16. Patches, Bundle e Archive — Git offline

> Parte do [Curso Completo de Git](./README.md)

## 16.1 `format-patch` / `apply` / `am`

```bash
# Gerar patches dos últimos 3 commits (arquivos .patch)
git format-patch -3 --stdout > fix.patch
git format-patch main..feature --output-directory=patches/

# Aplicar (sem commit)
git apply fix.patch && git diff          # só working
git apply --check fix.patch              # só testa

# Aplicar como commit (preserva autor/mensagem)
git am fix.patch
git am --abort
```

| `apply` | `am` |
|---------|------|
| Só patch no working | Cria commit |

## 16.2 `bundle` — repo em um arquivo

```bash
git bundle create portfolio.bundle HEAD main feature/hero
ls -lh portfolio.bundle   # um arquivo com todo histórico
git clone portfolio.bundle /tmp/restore
git bundle verify portfolio.bundle
```

> Útil para `air-gap` ou backup sem servidor.

## 16.3 `archive`

```bash
git archive --format=zip --output=portfolio.zip HEAD
git archive --format=tar HEAD portfolio/ | tar -t
```

---

⬅️ [Anterior: Worktree](./15-worktree-submodule.md) | ➡️ [17. Forense e Manutenção](./17-manutencao-forense.md) | [Sumário](./README.md)
