# 18. GitHub Avançado — Workflows, CODEOWNERS e Actions

> Parte do [Curso Completo de Git](./README.md)

## 18.1 GitFlow vs trunk-based

| Fluxo | Branches | Quando usar |
|-------|----------|-------------|
| **GitHub Flow** (cap. 11) | `main` + `feature/*` → PR → squash | Pequeno/médio, deploy contínuo |
| **GitFlow** | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*` | Releases versionadas, QA |
| **Trunk-based** | `main` + branches curtíssimas (<1 dia) | Time maduro, CI forte |

## 18.2 `CODEOWNERS` e proteção

```
# .github/CODEOWNERS
*               @org/team-lead
/portfolio/     @org/frontend
```

`Settings → Branches → Require review from CODEOWNERS, Require status checks`.

## 18.3 `gh` CLI e credenciais

```bash
gh auth login
gh repo create myapp --public --source=. --push
gh pr create --title "feat: hero" --body "Closes #12"
gh pr view --web
gh issue create --title "bug: hero"

# Credencial (Windows: Git Credential Manager; macOS: osxkeychain)
git config --global credential.helper manager  # ou osxkeychain / cache
# PAT (token) em vez de senha: GitHub → Settings → Developer settings → Tokens
```

## 18.4 GitHub Actions (mínimo)

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm test
```

> Actions roda a cada `push`/`PR` — é onde entra linter, testes e `pre-commit` (cap. 12).

---

⬅️ [Anterior: Forense](./17-manutencao-forense.md) | [Sumário](./README.md)
