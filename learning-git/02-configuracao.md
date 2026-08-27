# 02. Configuração, `init`, `clone` e `.gitignore` (dissecado)

> Parte do [Curso Completo de Git](./README.md)

## 2.1 `git config` — quem é você? (por escopo)

```bash
git config --global user.name "Seu Nome"          # 1. Nome que aparece no commit
git config --global user.email "seu@email.com"    # 2. Email deve bater com GitHub (para vincular)
git config --global init.defaultBranch main       # 3. Branch padrão (main vs master antigo)
git config --global core.editor "code --wait"     # 4. Editor que abre em git commit sem -m
git config --global core.autocrlf input           # 5. Windows: converte CRLF → LF no commit

git config --list --show-origin   # onde está salvo (arquivo)
git config user.email             # sem --global = só repo atual (--local)
```

| Escopo | Onde salva | Quando usar | Prioridade |
|--------|------------|-------------|------------|
| `--system` | `/etc/gitconfig` | Todos usuários da máquina | Menor |
| `--global` | `~/.gitconfig` ou `~/.config/git/config` | Você em todos repos (padrão) | Média |
| `--local` (padrão) | `.git/config` do repo | Só este repo (ex: email do trabalho diferente) | Maior |

**Dissecando:**

```bash
git config --global user.email "a@b.com"
# Escreve em ~/.gitconfig:
# [user]
#   email = a@b.com
git config --local user.email "work@empresa.com"
# Escreve em .git/config e prevalece no repo atual
```

**Erro clássico:**

```
Author identity unknown; please tell me who you are
→ Solução: git config --global user.name "Você" && git config --global user.email "voce@email.com"
```

## 2.2 `git init` vs `git clone` (quando usar cada)

```bash
# Cenário A: Novo do zero (pasta vazia → repo)
mkdir /tmp/portfolio && cd /tmp/portfolio
git init                    # cria .git/ (ainda sem commits)
git status                  # On branch main, No commits yet
```

```bash
# Cenário B: Clonar existente (baixa .git inteiro + working)
git clone https://github.com/usuario/repo.git        # HTTPS: pede senha/token (PAT)
git clone git@github.com:usuario/repo.git            # SSH: usa chave (cap. 12) — sem senha
git clone https://github.com/usuario/repo.git meu-nome # pasta custom (padrão é repo)
```

|  | `init` | `clone` |
|--|--------|---------|
| `.git` | Cria vazio | Baixa completo (todo histórico) |
| `remote origin` | Não cria (adicione manual) | Já cria `origin → URL` |
| Quando | Projeto novo local | Contribuir em repo existente |

> `clone` = `init` + `remote add origin` + `fetch` + `checkout main`.

## 2.3 `.gitignore` — o que **nunca** versionar (padrões dissecados)

```gitignore
# 1. Lixo do OS/Editor
.DS_Store
.vscode/
*.log

# 2. Segredos e env (nunca no Git!)
.env
.env.local

# 3. Dependências (reinstaláveis via npm/composer)
node_modules/
vendor/

# 4. Padrões avançados
*.tmp                    # todo .tmp
**/*.bak                 # em qualquer subpasta
!importante.bak          # exceção: não ignore este (negação com !)
portfolio/*.min.js       # só nessa pasta

# 5. Já rastreado? precisa sair do Git
# git rm --cached arquivo.log  → para de rastrear mas mantém no disco (ver cap. 03)
```

**Ordem de ignoração (primeira que casa vence):** `.gitignore` → `$HOME/.config/git/ignore` (global) → `.git/info/exclude` (só local, não compartilhado).

**Testar se está ignorando:**

```bash
git check-ignore -v arquivo.log   # diz qual regra e arquivo .gitignore ignorou
git status --ignored              # lista ignorados
git add -f arquivo.log            # força adicionar ignorado (raro, ex: .env.example)
```

**Erros comuns:**

| Mensagem | Causa | Solução |
|----------|-------|---------|
| `.gitignore não funcionou!` | Arquivo já estava com `git add` antes | `git rm --cached arquivo.log && git commit` |
| `!importante.bak` não funcionou | `!` só nega se o pai não foi ignorado | Não ignore a pasta pai com `*` |
| `warning: LF will be replaced by CRLF` | `core.autocrlf` no Windows | `git config --global core.autocrlf input` (ver 2.1) |

---

⬅️ [Anterior: Introdução](./01-introducao.md) | ➡️ [03. Staging, commit e histórico](./03-staging-commit.md) | [Sumário](./README.md)
