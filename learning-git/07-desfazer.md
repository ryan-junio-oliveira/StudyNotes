# 07. Desfazer — `reset`, `restore`, `revert`, `reflog` e `amend` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 7.1 Mapa: o que desfaz onde?

```
Working ── add ──► Staging ── commit ──► Repository
   ▲                   ▲                     │
   │ restore           │ restore --staged    │ reset / revert / amend
   └───────────────────┴─────────────────────┘
```

| Quer desfazer | Comando moderno | Comando antigo | Onde atua | Perde dado? |
|---------------|-----------------|----------------|-----------|-------------|
| Staging → Working | `git restore --staged arquivo` | `git reset arquivo` | Tira do `add` | Não |
| Working → HEAD | `git restore arquivo` | `git checkout -- arquivo` | Descarta edição | **Sim** (working) |
| Último commit (mantendo edição) | `git reset --soft HEAD~1` | — | Commit some, staging fica | Não |
| Commit + staging | `git reset --mixed HEAD~1` (padrão) | — | Commit+staging somem, working fica | Não |
| Tudo (commit+staging+working) | `git reset --hard HEAD~1` | — | Apaga tudo | **Sim** |

**Exemplos:**

```bash
git add index.html && git restore --staged index.html  # ou git reset index.html — tira do staging
echo "lixo" >> index.html && git restore index.html     # descarta working (irreversível)
git commit -m "oops" && git reset --soft HEAD~1        # desfaz commit, mantém staged (pode re-commitar)
git reset --hard HEAD~1                                # apaga último commit completamente
```

> **Mnemônico:** `--soft` = só commit, `--mixed` = commit+staging, `--hard` = tudo.

## 7.2 Reverter sem reescrever história (seguro para compartilhado)

```bash
git revert a1b2c3        # cria NOVO commit que desfaz a1b2c3 (mantém histórico)
git revert HEAD          # desfaz último
git revert --no-commit a1b2c3..HEAD  # desfaz range sem commitar ainda
```

| `reset` | `revert` |
|---------|----------|
| Reescreve histórico (muda hash) | Cria commit novo (não reescreve) |
| Perigoso em `main` compartilhada | Seguro em `main` |

## 7.3 `amend` e `reflog` — rede de segurança

```bash
git commit -m "feat: heri" && git commit --amend -m "feat: hero"  # corrige último (só se ainda não pushado!)
git commit --amend --no-edit --all                                 # inclui mudanças sem mudar mensagem

git reflog               # histórico de onde HEAD esteve (mesmo após reset --hard!)
# a1b2c3 HEAD@{0}: reset: moving to HEAD~1
# 8e2a1b HEAD@{1}: commit: feat: add hero
# Perdeu commit? git checkout a1b2c3 / git cherry-pick a1b2c3 (cap. 08)
```

## 7.4 Erros comuns

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `fatal: Cannot do a soft reset in the middle of a merge` | Tentou `reset` durante merge | `git merge --abort` ou finalize |
| `error: Your local changes would be overwritten by merge` | Working sujo | `git stash` (cap. 08) ou `commit` antes |
| `CONFLICT (modify/delete)` | Um apagou arquivo que outro editou | Escolha: `git rm` (apagar) ou `git add` (manter) |

> **Regra de ouro:** `reset --hard` e `push --force` só em branch **local/sua**. Em `main` compartilhada, use `revert`.

---

⬅️ [Anterior: Conflitos](./06-conflitos.md) | ➡️ [08. Rebase, Stash e Cherry-pick](./08-rebase-stash.md) | [Sumário](./README.md)
