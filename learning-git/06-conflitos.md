# 06. Conflitos — Quando dois mudam a mesma linha

> Parte do [Curso Completo de Git](./README.md)

## 6.1 Simular

```bash
git checkout -b feature/a
echo "Hero A" >> index.html && git commit -am "a: hero A"

git checkout main
echo "Hero B" >> index.html && git commit -am "b: hero B"

git merge feature/a
# Auto-merging index.html
# CONFLICT (content): Merge conflict in index.html
```

## 6.2 Marcadores

```html
<<<<<<< HEAD
Hero B
=======
Hero A
>>>>>>> feature/a
```

- `<<<<<<< HEAD` = seu (main)
- `=======` = separador
- `>>>>>>> feature/a` = deles

## 6.3 Resolver

```bash
# 1. Edite index.html (escolha A, B ou combine)
# 2. Marque como resolvido
git add index.html
git status  # all conflicts fixed
git commit  # mensagem de merge pré-preenchida
# ou aborte
git merge --abort
```

**Ferramentas visuais:** `git config merge.tool vscode && git mergetool`

> **Regra:** commit sempre em `main` limpo (`git status` clean) para merge previsível.

---

⬅️ [Anterior: Remotos](./05-remotos.md) | ➡️ [07. Desfazer](./07-desfazer.md) | [Sumário](./README.md)
