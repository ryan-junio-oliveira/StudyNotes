# 09. Tags — Versões imutáveis

> Parte do [Curso Completo de Git](./README.md)

## 9.1 Leve vs anotada

```bash
git tag v1.0.0                        # leve (ponteiro simples)
git tag -a v1.0.0 -m "Estável 1.0.0"  # anotada (objeto com autor, data, assinatura)
git tag -a v1.1.0 -m "feat" a1b2c3   # em commit específico
git show v1.0.0                       # detalhe
git tag                               # lista
```

## 9.2 SemVer e publicação

```
vMAJOR.MINOR.PATCH  ex: v2.1.3
MAJOR: quebra compatibilidade, MINOR: feat, PATCH: fix
```

```bash
git push origin v1.0.0        # uma tag
git push origin --tags        # todas
git tag -d v1.0.0             # local
git push --delete origin v1.0.0  # remota
# Recriar pushada: exige -f no push
```

> Tags são **imutáveis** — não `rebase` em cima delas. Branches movem, tags não.

---

⬅️ [Anterior: Rebase/Stash](./08-rebase-stash.md) | ➡️ [10. Convenções](./10-convencoes.md) | [Sumário](./README.md)
