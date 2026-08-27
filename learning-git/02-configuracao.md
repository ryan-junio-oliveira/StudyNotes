# 02. Configuração, `init`, `clone` e `.gitignore` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 2.1 `git config` — quem é você?

```bash
git config --global user.name "Seu Nome"          # 1. Nome que aparece no commit
git config --global user.email "seu@email.com"    # 2. Email (deve bater com GitHub)
git config --global init.defaultBranch main       # 3. Branch padrão (main vs master)
git config --global core.editor "code --wait"     # 4. Editor do commit

git config --list --show-origin   # onde está salvo (~/.gitconfig)
git config user.email             # só local (repo atual) vs --global
```

| Escopo | Onde salva | Quando usar |
|--------|------------|-------------|
| `--system` | `/etc/gitconfig` | todos usuários da máquina |
| `--global` | `~/.gitconfig` | você em todos repos |
| `--local` (padrão) | `.git/config` | só este repo (ex: email do trabalho diferente) |

**Sem config:**

```
Author identity unknown; please tell me who you are
→ git config --global user.name/email
```

## 2.2 `git init` vs `git clone`

```bash
# Novo do zero (pasta vazia → repo)
mkdir /tmp/portfolio && cd /tmp/portfolio
git init                    # cria .git/
git status                  # On branch main, No commits yet
```

```bash
# Clonar existente (baixa .git inteiro)
git clone https://github.com/usuario/repo.git        # HTTPS: pede senha/token
git clone git@github.com:usuario/repo.git            # SSH: usa chave (cap. 12)
git clone https://github.com/usuario/repo.git meu-nome # pasta custom
```

`clone` já faz `init + remote add origin + fetch`.

## 2.3 `.gitignore` — o que **não** versionar

```gitignore
# 1. Lixo do OS/Editor
.DS_Store
.vscode/
*.log

# 2. Segredos e env
.env
.env.local

# 3. Dependências (reinstaláveis)
node_modules/
vendor/

# 4. Padrões
*.tmp
**/*.bak          # em qualquer subpasta
!importante.bak   # exceção com !

# 5. Negar já rastreado
# git rm --cached arquivo.log  → para de rastrear mas mantém no disco (cap. 03)
```

**Ordem de ignoração:** `.gitignore` → `$HOME/.config/git/ignore` → `.git/info/exclude`.

**Testar se está ignorando:**

```bash
git check-ignore -v arquivo.log   # diz qual regra ignorou
git add -f arquivo.log            # força adicionar ignorado (raro)
```

**Erro comum:**

```
.gitignore não funcionou!
→ arquivo já estava com git add antes — faça git rm --cached
```

---

⬅️ [Anterior: Introdução](./01-introducao.md) | ➡️ [03. Staging, commit e histórico](./03-staging-commit.md) | [Sumário](./README.md)
