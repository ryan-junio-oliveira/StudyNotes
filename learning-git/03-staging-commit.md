# 03. Área de Staging, `commit`, `status`, `diff` e `log` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 3.1 O ciclo de vida do arquivo

```
Untracked ── git add ──► Staged ── git commit ──► Committed
   ↑                          │
   └──── git rm --cached ─────┘
```

```bash
touch index.html          # Untracked
git status                # Untracked files: index.html (vermelho)
git add index.html        # vai para Staging (verde)
git status                # Changes to be committed: new file: index.html
git commit -m "feat: add homepage"  # congela → Committed (limpo)
git status                # nothing to commit, working tree clean
```

| Comando | O que faz | Se errar |
|---------|-----------|----------|
| `git add .` | Adiciona tudo (respeita .gitignore) | Adicionou demais? `git reset` (cap. 07) |
| `git add -p` | Adiciona por pedaços (patch) — revisa cada hunk | Ideal para commit cirúrgico |
| `git rm --cached arquivo` | Sai do Git mas mantém no disco | `git rm` sem --cached apaga do disco! |

## 3.2 `git commit` — a unidade de histórico

```bash
git commit -m "feat: add hero section"           # 1. Mensagem curta
git commit -m "feat: add hero" -m "Detalhe longo" # 2. Título + corpo
git commit -am "fix: typo"                       # 3. -a = add automático (só tracked! não pega untracked)
git commit --amend -m "nova mensagem"            # 4. Corrige último commit (ainda não pushado)
```

Cada commit guarda: **hash (ex: a1b2c3), autor, data, mensagem, pai(s) e snapshot**.

> Mensagem boa = `tipo: o que` (ver cap. 10 convenções).

## 3.3 `git status` e `git diff` — onde estou?

```bash
git status               # resumo humano (use sempre antes de commit!)
git status -s            # curto: M index.html, ?? novo.txt, A staged

git diff                 # working vs staging (o que ainda não deu add)
git diff --staged        # staging vs último commit (o que vai commitar)
git diff HEAD            # working vs último commit (tudo)
git diff main..feature   # entre branches
```

## 3.4 `git log` — ler história

```bash
git log                          # completo (q para sair)
git log --oneline --graph --decorate --all  # grafo compacto (use sempre!)
git log -p                       # mostra diff de cada commit
git log --stat                   # arquivos mudados
git log --since="2 weeks ago" --author="Ana"
git show a1b2c3                   # detalhe de um commit
```

**Exemplo com portfolio:**

```bash
cp -r projeto-portfolio /tmp/portfolio && cd /tmp/portfolio
git init && git add . && git commit -m "feat: initial portfolio"
echo "<!-- hero -->" >> index.html && git add index.html && git commit -m "feat: add hero"
git log --oneline --graph
# * 8e2a1b feat: add hero
# * a1b2c3 feat: initial portfolio
```

---

⬅️ [Anterior: Configuração](./02-configuracao.md) | ➡️ [04. Branches](./04-branches.md) | [Sumário](./README.md)
