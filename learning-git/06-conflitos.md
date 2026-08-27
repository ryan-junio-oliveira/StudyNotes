# 06. Conflitos — Quando dois mudam a mesma linha (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 6.1 Simular (faça junto)

```bash
git checkout -b feature/a
echo "Hero A" >> index.html && git commit -am "a: hero A"

git checkout main
echo "Hero B" >> index.html && git commit -am "b: hero B"

git merge feature/a
# Auto-merging index.html
# CONFLICT (content): Merge conflict in index.html
# Automatic merge failed; fix conflicts and then commit the result.
```

## 6.2 Marcadores — linha a linha

Git injeta no arquivo:

```html
<<<<<<< HEAD       ← seu (main), onde HEAD está
Hero B
=======            ← separador
Hero A
>>>>>>> feature/a  ← deles (branch que tenta mesclar)
```

| Marcador | Significado |
|----------|-------------|
| `<<<<<<< HEAD` | Início do seu trecho |
| `=======` | Divisa |
| `>>>>>>> feature/a` | Fim do deles |

> **Não é erro:** é Git pedindo "escolha A, B ou combine os dois".

## 6.3 Resolver (passo a passo)

```bash
# 1. Abra index.html e edite: apague marcadores, deixe "Hero A + B" ou escolha um
# 2. Marque como resolvido
git add index.html
git status  # all conflicts fixed but you are still merging

# 3. Finalize
git commit  # mensagem de merge pré-preenchida (não mude sem motivo)

# Ou aborte tudo
git merge --abort  # volta ao antes do merge
```

**Ferramentas visuais:**

```bash
git config --global merge.tool vscode  # ou meld, p4merge
git mergetool  # abre editor visual com 3 painéis
```

**Conflito binário (imagem):**

```
warning: Cannot merge binary files: logo.png (HEAD vs. feature/a)
→ escolha: git checkout --ours logo.png (seu) ou --theirs (deles), depois git add
```

> **Regra:** comece merge com `working tree clean` (`git status` limpo) — sujeira mistura com conflito.

---

⬅️ [Anterior: Remotos](./05-remotos.md) | ➡️ [07. Desfazer](./07-desfazer.md) | [Sumário](./README.md)
