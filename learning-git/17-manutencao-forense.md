# 17. Forense, Manutenção e Assinatura

> Parte do [Curso Completo de Git](./README.md)

## 17.1 Forense — quem quebrou?

```bash
git blame index.html                   # linha-a-linha: hash + autor + data
git blame -L 10,20 index.html
git log --follow -- index.html         # segue renames
git log -S "Hero" --oneline            # pickaxe: commits que adicionaram/removeram "Hero"
git log -G "Hero.*A" --oneline         # diff com regex
git shortlog -sn --since="1 month ago" # ranking por autor
git show a1b2c3 --stat --patch         # commit + diff
```

## 17.2 `rebase --onto` e `rerere`

```bash
# Rebase cirúrgico: mover feature de main para outro base
git rebase --onto newBase oldBase feature

# rerere: Reuse Recorded Resolution (lembra como você resolveu conflito)
git config --global rerere.enabled true
# Na próxima vez que o mesmo conflito aparecer, Git resolve sozinho
```

## 17.3 `filter-repo` / `BFG` — limpar histórico

> Vazou `.env`? Não é `git rm`, é reescrever histórico.

```bash
# git filter-repo (substitui filter-branch)
pip install git-filter-repo
git filter-repo --path .env --invert-paths  # apaga .env de TODO histórico
# BFG Repo-Cleaner (JVM)
java -jar bfg.jar --delete-files .env repo.git
# Depois: git push --force-with-lease --all && avise o time para re-clonar
```

## 17.4 `gc`, `reflog expire` e assinatura

```bash
git gc --prune=now --aggressive    # compacta objetos
git reflog expire --expire=now --all && git gc --prune=now # apaga reflog (perigoso)

# Assinatura GPG/SSH (supply-chain)
git config --global commit.gpgsign true
git config --global user.signingkey 3AA5C34371567BD2  # gpg --list-secret-keys
git commit -S -m "feat: signed"
git log --show-signature
git tag -s v1.0.0 -m "signed tag"
git verify-commit HEAD
```

---

⬅️ [Anterior: Patches](./16-patches-bundle.md) | ➡️ [18. GitHub Avançado](./18-github-avancado.md) | [Sumário](./README.md)
