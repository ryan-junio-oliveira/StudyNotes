# 07. Desfazer — `reset`, `restore`, `revert`, `reflog` e `amend`

> Parte do [Curso Completo de Git](./README.md)

## 7.1 Área por área

| Quer desfazer | Comando | Onde atua |
|---------------|---------|-----------|
| Staging → working | `git restore --staged arquivo` / `git reset arquivo` | Sai do `add` |
| Working → HEAD | `git restore arquivo` / `git checkout -- arquivo` | Descarta edição |
| Último commit (mantendo edição) | `git reset --soft HEAD~1` | Commit some, staging fica |
| Último commit + staging | `git reset --mixed HEAD~1` (padrão) | Commit+staging somem, working fica |
| Tudo (perigoso) | `git reset --hard HEAD~1` | Apaga commit+staging+working |

```bash
git add index.html && git reset index.html          # tira do staging
echo "lixo" >> index.html && git restore index.html # descarta working
git commit -m "oops" && git reset --soft HEAD~1    # desfaz commit, mantém staged
```

## 7.2 Reverter sem reescrever história

```bash
git revert a1b2c3        # cria novo commit que desfaz a1b2c3 (seguro para compartilhado)
git revert HEAD          # desfaz último
git revert --no-commit a1b2c3..HEAD  # desfaz range
```

## 7.3 `amend` e `reflog` — rede de segurança

```bash
git commit -m "feat: heri" && git commit --amend -m "feat: hero"  # corrige último (não pushado)

git reflog               # histórico de HEAD (onde esteve), mesmo após reset --hard
# a1b2c3 HEAD@{0}: reset: moving to HEAD~1
# encontrou hash perdido? git checkout a1b2c3 / git cherry-pick a1b2c3
```

> **Regra de ouro:** `reset --hard` e `push --force` só em branch **local/sua**. Em `main` compartilhada, use `revert`.

**Erro comum:**

```
fatal: Cannot do a soft reset in the middle of a merge
→ finalize ou aborte merge: git merge --abort
```

---

⬅️ [Anterior: Conflitos](./06-conflitos.md) | ➡️ [08. Rebase, Stash e Cherry-pick](./08-rebase-stash.md) | [Sumário](./README.md)
