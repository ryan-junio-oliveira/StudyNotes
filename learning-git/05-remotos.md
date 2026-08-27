# 05. Remotos — `origin`, `push`, `pull` e `fetch` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 5.1 O que é `origin`?

`origin` é só um **apelido** para URL:

```bash
git remote -v                    # lista: origin  https://github.com/user/repo.git (fetch/push)
git remote add origin git@github.com:user/repo.git
git remote set-url origin git@github.com:user/repo.git  # troca HTTPS → SSH
git remote remove origin
```

## 5.2 `push` / `fetch` / `pull`

```
local main (a1b2c3) ── git push origin main ──►  origin/main (GitHub)
local main (a1b2c3) ◄── git fetch origin ──  origin/main (atualiza cópia local do remoto, sem mexer no working)
local main           ◄── git pull origin main ──  = fetch + merge
```

```bash
git push origin feature/hero              # publica branch
git push -u origin feature/hero           # -u = set upstream (depois só git push/pull sem args)
git push --force-with-lease               # força só se ninguém atualizou remoto (seguro vs --force)
git fetch origin                          # baixa origin/main sem mesclar — seguro para inspecionar
git pull origin main                      # fetch + merge (pode dar conflito — cap. 06)
git pull --rebase origin main             # fetch + rebase (histórico linear)
```

| Comando | Altera working? | Perigo |
|---------|-----------------|--------|
| `fetch` | Não | Nenhum |
| `pull` | Sim | Conflito; prefira `fetch` + `merge` explícito |
| `push --force` | Reescreve remoto | Perde commits alheios — use `--force-with-lease` |

## 5.3 Rastreamento (tracking)

```bash
git branch --set-upstream-to=origin/main main
git branch -vv  # mostra tracking: main [origin/main: ahead 2]
git push --delete origin feature/hero  # apaga remota
```

**Erro comum:**

```
! [rejected] main -> main (fetch first)
→ remoto tem commits que você não tem — faça git pull --rebase

fatal: The current branch has no upstream
→ git push -u origin nome-da-branch
```

---

⬅️ [Anterior: Branches](./04-branches.md) | ➡️ [06. Conflitos](./06-conflitos.md) | [Sumário](./README.md)
