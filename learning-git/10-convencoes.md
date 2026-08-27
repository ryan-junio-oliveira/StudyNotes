# 10. Convenções — Conventional Commits e Aliases

> Parte do [Curso Completo de Git](./README.md)

## 10.1 Conventional Commits

```
<tipo>(escopo): <descrição>
feat(auth): add login       # feat = nova feature → MINOR
fix(api): handle null       # fix = correção → PATCH
docs(readme): update        # chore, docs, refactor, test, build...
feat!: drop node 14         # ! = BREAKING CHANGE → MAJOR
```

```bash
git log --oneline --grep="feat:"   # filtra por tipo
```

**Por que?** Gera `CHANGELOG`, `SemVer` automático e `git bisect` previsível.

## 10.2 Aliases — digite menos

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.lg "log --oneline --graph --decorate --all"
git config --global alias.amend "commit --amend --no-edit"

# Agora:
git st && git lg
```

## 10.3 `.gitattributes` e `clean`

```bash
git add . && git commit -m "chore: update"
git clean -fdx   # apaga untracked + ignorados (perigoso: -n = dry-run primeiro)
```

---

⬅️ [Anterior: Tags](./09-tags.md) | ➡️ [11. GitHub Flow](./11-github-flow.md) | [Sumário](./README.md)
