# 05. Remotos — `origin`, `push`, `pull` e `fetch` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 5.1 O que é `origin`? (apelido para URL)

```bash
git remote -v                    # lista: origin  https://github.com/user/repo.git (fetch) (push)
git remote add origin git@github.com:user/repo.git
git remote set-url origin git@github.com:user/repo.git  # troca HTTPS → SSH (cap. 12)
git remote remove origin
git remote rename origin upstream
```

`origin` não é mágico — é só o nome padrão que `clone` cria.

## 5.2 `push` / `fetch` / `pull` (visual)

```
local main (a1b2c3) ── git push origin main ──►  origin/main (GitHub)

local main (a1b2c3) ◄── git fetch origin ──  origin/main (atualiza cópia local do remoto, SEM mexer no working)
                                                    ↑ origin/main é só um ponteiro local que espelha o remoto

local main           ◄── git pull origin main ──  = fetch + merge (mexe no working, pode dar conflito)
```

| Comando | Altera working? | Pode dar conflito? | Perigo |
|---------|-----------------|-------------------|--------|
| `git fetch origin` | Não | Não | Nenhum — seguro para inspecionar |
| `git pull origin main` | Sim | Sim | Merge implícito; prefira `fetch` + `merge` explícito |
| `git push origin feature/hero` | Envia | Não, mas pode ser rejeitado | Reescreve remoto se `--force` |

```bash
git push origin feature/hero              # publica branch
git push -u origin feature/hero           # -u = --set-upstream (depois só git push/pull sem args)
git push --force-with-lease               # força só se ninguém atualizou remoto (seguro vs --force que perde commits alheios)
git fetch origin                          # baixa origin/main sem mesclar — inspecione com git log HEAD..origin/main
git pull origin main                      # fetch + merge
git pull --rebase origin main             # fetch + rebase (histórico linear, ver cap. 08)
```

## 5.3 Rastreamento (tracking / upstream)

Quando você faz `git push -u origin feature/hero`, cria:

```
feature/hero (local)  ── upstream ──►  origin/feature/hero (remoto)
```

```bash
git branch --set-upstream-to=origin/main main
git branch -vv  # mostra: main [origin/main: ahead 2, behind 1] 8e2a1b feat
git push --delete origin feature/hero  # apaga remota (equivale a git push origin --delete)
git branch --unset-upstream feature/hero
```

**Ver o que vai puxar/enviar:**

```bash
git fetch && git log --oneline HEAD..origin/main   # commits que o remoto tem e você não
git log --oneline origin/main..HEAD                # commits que você tem e o remoto não
```

## 5.4 Erros comuns

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `! [rejected] main -> main (fetch first)` | Remoto tem commits que você não tem | `git pull --rebase` ou `fetch` + `merge` |
| `fatal: The current branch has no upstream` | Sem `-u` no primeiro push | `git push -u origin nome-da-branch` |
| `fatal: refusing to merge unrelated histories` | Dois `init` independentes | `git pull origin main --allow-unrelated-histories` (primeira vez) |
| `remote origin already exists` | Já tem origin | `git remote set-url` em vez de `add` |

---

⬅️ [Anterior: Branches](./04-branches.md) | ➡️ [06. Conflitos](./06-conflitos.md) | [Sumário](./README.md)
