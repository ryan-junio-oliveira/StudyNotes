# 13. Projeto Portfolio — Laboratório passo a passo

> Parte do [Curso Completo de Git](./README.md) — **Faça junto.** Copie `projeto-portfolio/` para `/tmp/portfolio` e execute cada bloco.

```bash
cp -r learning-git/projeto-portfolio /tmp/portfolio && cd /tmp/portfolio
git init && git config user.name "Você" && git config user.email "voce@email.com"
git add . && git commit -m "feat: initial portfolio" && git log --oneline
```

## Cap. 03 → Staging

```bash
echo "<section>Hero</section>" >> index.html
git status && git diff && git add index.html && git commit -m "feat: add hero"
```

## Cap. 04 → Branches

```bash
git checkout -b feature/contato
echo "<section>Contato</section>" >> index.html
git commit -am "feat: add contato" && git checkout main && git merge feature/contato --no-ff
git log --oneline --graph --all
```

## Cap. 05 → Remoto

```bash
gh repo create portfolio --public --source=. --push  # ou manual: git remote add origin ...
git push -u origin main
```

## Cap. 06 → Conflito (provoque!)

```bash
git checkout -b feature/a && echo "A" >> style.css && git commit -am "a"
git checkout main && echo "B" >> style.css && git commit -am "b"
git merge feature/a  # CONFLICT → edite style.css, git add ., git commit
```

## Cap. 07 → Desfazer

```bash
git add index.html && git reset index.html  # unstaging
git commit --amend -m "feat: add hero (typo fix)"
git revert HEAD --no-edit
```

## Cap. 08 → Rebase e Stash

```bash
git checkout -b feature/tema && echo "dark" >> style.css && git commit -am "feat: tema"
git stash push -m "wip" && git checkout main && git stash pop
git rebase main  # na feature
```

## Cap. 09 → Tag

```bash
git tag -a v1.0.0 -m "Release 1.0" && git push origin v1.0.0
```

> Repita o fluxo `feature → PR → merge → tag` até dominar. Este lab resume todo o curso.

---

⬅️ [Anterior: SSH/LFS/Hooks](./12-ssh-lfs-hooks.md) | ➡️ [14. Boas Práticas](./14-boas-praticas.md) | [Sumário](./README.md)
