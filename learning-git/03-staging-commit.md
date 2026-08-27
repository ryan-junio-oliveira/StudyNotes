# 03. Área de Staging, `commit`, `status`, `diff` e `log` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 3.1 Ciclo de vida do arquivo (visual)

```
Untracked ── git add ──► Staged ── git commit ──► Committed (clean)
   ↑                          │
   └──── git rm --cached ─────┘     git restore --staged volta para Untracked
   git restore descarta working
```

**Lab:**

```bash
touch index.html          # Untracked
git status                # Untracked files: index.html (vermelho)
git add index.html        # vai para Staging (verde)
git status                # Changes to be committed: new file: index.html
git commit -m "feat: add homepage"  # congela → Committed
git status                # nothing to commit, working tree clean
```

| Comando | O que faz | Armadilha |
|---------|-----------|-----------|
| `git add .` | Adiciona tudo (respeita `.gitignore`) | Adicionou demais? `git reset` (cap. 07) |
| `git add index.html` | Adiciona só um arquivo | Esquecer de dar `add` → commit vazio |
| `git add -p` | Pergunta por hunk (`y/n/s/e`): commit cirúrgico | Ideal para separar 2 ideias no mesmo arquivo |
| `git rm --cached arquivo` | Sai do Git mas mantém no disco | `git rm` sem `--cached` apaga do disco! |
| `git restore --staged arquivo` | Tira do staging (moderno, Git 2.23+) | Equivale a `git reset arquivo` |

> **Regra:** `git status` antes e depois de cada `add`/`commit`.

## 3.2 `git commit` — a unidade de histórico (dissecado)

Cada commit guarda: **hash** (`a1b2c3`), **autor**, **data**, **mensagem**, **pai(s)** e **snapshot**.

```bash
git commit -m "feat: add hero section"                    # 1. Mensagem curta (50 chars ideal)
git commit -m "feat: add hero" -m "Detalhe longo no corpo" # 2. Título + corpo (linha em branco separa)
git commit -am "fix: typo"                                # 3. -a = add automático (só tracked! não pega untracked)
git commit --amend -m "nova mensagem"                     # 4. Corrige último commit (só se ainda não pushado!)
git commit --amend --no-edit --all                        # 5. Inclui mudanças sem mudar mensagem
```

**O que `-a` não faz:**

```bash
touch novo.html && git commit -am "teste"
# novo.html continua Untracked! -a só adiciona Modified/Deleted já rastreados
```

> Mensagem boa = `tipo: o que` (ver cap. 10 convenções). `feat`, `fix`, `docs`, `refactor`.

## 3.3 `git status` e `git diff` — onde estou? (tabela)

```bash
git status               # humano: branch, staged, unstaged, untracked (use sempre!)
git status -s            # curto: M index.html (Modified), ?? novo.txt, A staged, D deleted
git status --ignored     # mostra ignorados
```

| `git diff` | Compara | Quando usar |
|------------|---------|-------------|
| `git diff` | Working vs Staging | "O que ainda não dei add?" |
| `git diff --staged` (ou `--cached`) | Staging vs último commit | "O que vai commitar?" |
| `git diff HEAD` | Working vs último commit | "Tudo que mudou desde o último commit" |
| `git diff main..feature` | Entre branches | "O que feature tem que main não tem?" |
| `git diff --word-diff` | Por palavra | Útil para `README.md` |

**Exemplo:**

```bash
echo "hero" >> index.html && git diff          # vê +hero no working
git add index.html && git diff                  # vazio (já foi para staging)
git diff --staged                               # vê +hero no staging
```

## 3.4 `git log` — ler história (formatos)

```bash
git log                          # completo (q para sair)
git log --oneline --graph --decorate --all  # ★ use sempre! grafo compacto
git log -p                       # patch: mostra diff de cada commit
git log --stat                   # arquivos mudados por commit
git log --since="2 weeks ago" --author="Ana" --grep="feat"
git log -- index.html            # histórico só deste arquivo
git show a1b2c3                   # detalhe de 1 commit (diff + mensagem)
git show HEAD: index.html        # arquivo como estava naquele commit
```

**Lab com portfolio:**

```bash
cp -r projeto-portfolio /tmp/portfolio && cd /tmp/portfolio
git init && git add . && git commit -m "feat: initial portfolio"
echo "<!-- hero -->" >> index.html && git add index.html && git commit -m "feat: add hero"
git log --oneline --graph --all
# * 8e2a1b (HEAD -> main) feat: add hero
# * a1b2c3 feat: initial portfolio
```

**Erro comum:**

```
nothing added to commit but untracked files present
→ você editou mas esqueceu git add

pathspec 'arquivo' did not match any files
→ nome errado ou arquivo ignorado por .gitignore
```

---

⬅️ [Anterior: Configuração](./02-configuracao.md) | ➡️ [04. Branches](./04-branches.md) | [Sumário](./README.md)
