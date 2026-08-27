# 12. SSH, LFS e Hooks

> Parte do [Curso Completo de Git](./README.md)

## 12.1 SSH — sem senha

```bash
ssh-keygen -t ed25519 -C "seu@email.com"  # RSA se não suportar: -t rsa -b 4096
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub           # Linux/macOS
clip < ~/.ssh/id_ed25519.pub        # Git Bash Windows
cat ~/.ssh/id_ed25519.pub | clip    # PowerShell
# GitHub → Settings → SSH and GPG keys → New SSH key → colar

ssh -T git@github.com               # Hi user! You've successfully authenticated.
git remote set-url origin git@github.com:user/repo.git
```

## 12.2 Git LFS — arquivos grandes

```bash
git lfs install
git lfs track "*.exe" "*.psd" "*.zip"
git add .gitattributes                # commitar!
git add jogo.exe && git commit -m "feat: add binary" && git push
git lfs ls-files                      # verifica
```

## 12.3 Hooks — scripts automáticos

```bash
cat .git/hooks/pre-commit  # exemplo: roda linter antes de commit

#!/bin/sh
npm run lint || exit 1     # bloqueia commit se lint falhar

chmod +x .git/hooks/pre-commit
# Frameworks: husky (JS), pre-commit (Python)
```

---

⬅️ [Anterior: GitHub Flow](./11-github-flow.md) | ➡️ [13. Projeto Portfolio (lab)](./13-projeto-portfolio.md) | [Sumário](./README.md)
