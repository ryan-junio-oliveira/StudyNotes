# 08. Rebase, Stash, Cherry-pick e Bisect

> Parte do [Curso Completo de Git](./README.md)

## 8.1 `merge` vs `rebase` — histórico

```
merge:        *──●──M (merge commit com 2 pais)
rebase:       *──●'──●'  (replay linear, sem M)
```

```bash
git checkout feature/hero && git rebase main  # re-aplica seus commits sobre main
git rebase --abort / --continue               # em conflito, igual merge
git rebase -i HEAD~3                          # interativo: squash, reword, drop
```

|  | `merge` | `rebase` |
|--|---------|----------|
| Histórico | Verdadeiro, com M | Linear, reescrito |
| Quando usar | `main` compartilhada | Feature local antes de push |
| Perigo | Nenhum | Reescreve hash — nunca em branch já pushada por outros |

## 8.2 `stash` — gaveta temporária

```bash
# Meio de uma feature, precisa trocar de branch com sujeira
git stash push -m "wip: hero"   # guarda working+staging na gaveta
git status # clean → pode checkout
git stash list                  # stash@{0}: wip: hero
git stash pop                   # aplica e remove da gaveta
git stash apply                 # aplica e mantém
git stash drop stash@{0}
```

## 8.3 `cherry-pick` e `bisect`

```bash
git cherry-pick a1b2c3          # traz 1 commit de outra branch (sem merge)
git cherry-pick --abort

git bisect start
git bisect bad                  # commit atual está ruim
git bisect good v1.0.0          # commit bom conhecido
# Git bissecta ao meio — teste e diga good/bad até achar culpado
git bisect reset
```

---

⬅️ [Anterior: Desfazer](./07-desfazer.md) | ➡️ [09. Tags](./09-tags.md) | [Sumário](./README.md)
